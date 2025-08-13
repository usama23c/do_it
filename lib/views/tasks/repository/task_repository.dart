import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/task_model.dart';

class TaskRepository {
  final Box<TaskModel> _box;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  TaskRepository({
    required Box<TaskModel> box,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    required FlutterLocalNotificationsPlugin notificationsPlugin,
  })  : _box = box,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _notificationsPlugin = notificationsPlugin;

  Future<void> startRealtimeSync() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // initial download: (optional) ensure local box has latest server copy
    final serverSnapshot = await _firestore.collection('tasks')
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in serverSnapshot.docs) {
      final map = {...doc.data(), 'firebaseId': doc.id};
      final serverTask = TaskModel.fromMap(map);

      // If local has same firebaseId, decide by updatedAt
      final local = _box.values.firstWhere(
            (t) => t.firebaseId == doc.id,
        orElse: () => serverTask,
      );

      if (local.firebaseId == null) {
        // no local: add
        serverTask.firebaseId = doc.id;
        await _box.add(serverTask);
      } else {
        // if server is newer, replace local
        if (serverTask.updatedAt.isAfter(local.updatedAt)) {
          await local.delete(); // remove old object
          await _box.add(serverTask);
        }
      }
    }

    // Listen to remote changes
    _subscription = _firestore
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) async {
      for (var change in snapshot.docChanges) {
        final data = change.doc.data()!;
        final firebaseId = change.doc.id;
        final remoteTask = TaskModel.fromMap({...data, 'firebaseId': firebaseId});

        final localIndex = _box.values.toList().indexWhere((t) => t.firebaseId == firebaseId);

        if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
          // If local exists, compare updatedAt
          if (localIndex != -1) {
            final local = _box.getAt(localIndex)!;
            if (remoteTask.updatedAt.isAfter(local.updatedAt)) {
              await _box.putAt(localIndex, remoteTask);
            }
          } else {
            await _box.add(remoteTask);
          }
        } else if (change.type == DocumentChangeType.removed) {
          if (localIndex != -1) {
            await _box.deleteAt(localIndex);
          }
        }
      }
    });
  }

  Future<void> stopRealtimeSync() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> createTask(TaskModel t) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    // create in Firestore
    final docRef = await _firestore.collection('tasks').add({
      ...t.toMap(),
      'userId': uid,
    });

    t.firebaseId = docRef.id;
    t.updatedAt = DateTime.now();

    // store locally
    await _box.add(t);

    // schedule notification
    await _scheduleNotification(t);
  }

  Future<void> updateTask(TaskModel localTask) async {
    final uid = _auth.currentUser?.uid;
    localTask.updatedAt = DateTime.now();

    // update firestore if firebaseId exists
    if (localTask.firebaseId != null) {
      await _firestore.collection('tasks').doc(localTask.firebaseId).set({
        ...localTask.toMap(),
        'userId': uid,
      });
    } else {
      // create remote copy if missing
      final docRef = await _firestore.collection('tasks').add({
        ...localTask.toMap(),
        'userId': uid,
      });
      localTask.firebaseId = docRef.id;
    }

    // update local: find and replace
    final index = _box.values.toList().indexWhere((t) => t.firebaseId == localTask.firebaseId);
    if (index != -1) {
      await _box.putAt(index, localTask);
    } else {
      await _box.add(localTask);
    }

    await _scheduleNotification(localTask);
  }

  Future<void> deleteTask(TaskModel t) async {
    // remove remote
    if (t.firebaseId != null) {
      await _firestore.collection('tasks').doc(t.firebaseId).delete();
    }

    // remove local
    final idx = _box.values.toList().indexWhere((x) => x.firebaseId == t.firebaseId);
    if (idx != -1) await _box.deleteAt(idx);

    // cancel notification if any
    await _cancelNotification(t);
  }

  Future<void> _scheduleNotification(TaskModel task) async {
    if (!task.reminder) return;
    final scheduledTime = task.time.subtract(const Duration(minutes: 15));
    if (scheduledTime.isBefore(DateTime.now())) return;

    final id = task.firebaseId?.hashCode ?? task.title.hashCode;

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      'Reminder: ${task.title}',
      task.description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
     // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _cancelNotification(TaskModel task) async {
    final id = task.firebaseId?.hashCode ?? task.title.hashCode;
    await _notificationsPlugin.cancel(id);
  }
}
