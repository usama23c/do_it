// import 'package:hive/hive.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// part 'task_model.g.dart';
//
// @HiveType(typeId: 0)
// class TaskModel extends HiveObject {
//   @HiveField(0)
//   String title;
//
//   @HiveField(1)
//   String description;
//
//   @HiveField(2)
//   String priority;
//
//   @HiveField(3)
//   DateTime date;
//
//   @HiveField(4)
//   DateTime time;
//
//   @HiveField(5)
//   bool reminder;
//
//   @HiveField(6)
//   bool isCompleted;
//
//   @HiveField(7)
//   String category;
//
//   @HiveField(8)
//   bool isNamaz;
//
//   @HiveField(9)
//   String? namazKey;
//
//   @HiveField(10)
//   String? firebaseId; // ✅ no 'late', no 'final'
//
//   TaskModel({
//     required this.title,
//     required this.description,
//     required this.priority,
//     required this.date,
//     required this.time,
//     this.reminder = false,
//     this.isCompleted = false,
//     this.category = 'Event',
//     this.isNamaz = false,
//     this.namazKey,
//     this.firebaseId,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'description': description,
//       'priority': priority,
//       'date': Timestamp.fromDate(date),
//       'time': Timestamp.fromDate(time),
//       'reminder': reminder,
//       'isCompleted': isCompleted,
//       'category': category,
//       'isNamaz': isNamaz,
//       'namazKey': namazKey,
//       'firebaseId': firebaseId,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//   }
//
//   factory TaskModel.fromMap(Map<String, dynamic> map) {
//     return TaskModel(
//       title: map['title'] ?? '',
//       description: map['description'] ?? '',
//       priority: map['priority'] ?? 'Medium',
//       date: (map['date'] as Timestamp).toDate(),
//       time: (map['time'] as Timestamp).toDate(),
//       reminder: map['reminder'] ?? false,
//       isCompleted: map['isCompleted'] ?? false,
//       category: map['category'] ?? 'Event',
//       isNamaz: map['isNamaz'] ?? false,
//       namazKey: map['namazKey'],
//       firebaseId: map['firebaseId'],
//     );
//   }
// }
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String priority;

  @HiveField(3)
  DateTime date; // just the date part (for display)

  @HiveField(4)
  DateTime time; // full DateTime for scheduling

  @HiveField(5)
  bool reminder;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  String category;

  @HiveField(8)
  bool isNamaz;

  @HiveField(9)
  String? namazKey; // e.g. fajr/dhuhr etc.

  @HiveField(10)
  String? firebaseId;

  @HiveField(11)
  DateTime updatedAt; // last update timestamp (for conflict resolution)

  TaskModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.time,
    this.reminder = false,
    this.isCompleted = false,
    this.category = 'Event',
    this.isNamaz = false,
    this.namazKey,
    this.firebaseId,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'reminder': reminder,
      'isCompleted': isCompleted,
      'category': category,
      'isNamaz': isNamaz,
      'namazKey': namazKey,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      reminder: map['reminder'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
      category: map['category'] ?? 'Event',
      isNamaz: map['isNamaz'] ?? false,
      namazKey: map['namazKey'],
      firebaseId: map['firebaseId'],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  // A helper to copy with change
  TaskModel copyWith({
    String? title,
    String? description,
    String? priority,
    DateTime? date,
    DateTime? time,
    bool? reminder,
    bool? isCompleted,
    String? category,
    bool? isNamaz,
    String? namazKey,
    String? firebaseId,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      time: time ?? this.time,
      reminder: reminder ?? this.reminder,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      isNamaz: isNamaz ?? this.isNamaz,
      namazKey: namazKey ?? this.namazKey,
      firebaseId: firebaseId ?? this.firebaseId,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
