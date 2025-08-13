// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:hive/hive.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../model/task_model.dart';
//
// class NamazService {
//   // Base URL for the API (you pasted an Aladhan-like endpoint)
//   static const _base = 'https://api.aladhan.com/v1';
//
//   /// Fetch timings for [date] (format dd-MM-yyyy) and [address].
//   /// If [saveToBoxes] is true, will create TaskModel Namaz entries in Hive and Firestore
//   /// but will avoid duplicates via namazKey (date|prayerName).
//   static Future<Map<String, String>?> fetchTimingsByAddress({
//     required DateTime date,
//     required String address,
//     String? apiKey7x,
//     int? method,
//     bool saveToBoxes = true,
//   }) async {
//     final dateStr = "${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}";
//     final params = {
//       'address': address,
//       if (apiKey7x != null) 'x7xapikey': apiKey7x,
//       if (method != null) 'method': method.toString(),
//       'iso8601': 'false',
//     };
//
//     final uri = Uri.parse('$_base/timingsByAddress/$dateStr').replace(queryParameters: params);
//
//     final res = await http.get(uri);
//     if (res.statusCode != 200) {
//       throw Exception('Failed to fetch namaz timings: ${res.statusCode}');
//     }
//
//     final body = jsonDecode(res.body) as Map<String, dynamic>;
//     if (body['code'] != 200 || body['data'] == null) {
//       throw Exception('Unexpected API response: ${res.body}');
//     }
//
//     final data = body['data'] as Map<String, dynamic>;
//     final timings = (data['timings'] as Map).cast<String, dynamic>();
//
//     // We only keep the core prayer keys (Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha).
//     // Some endpoints include extra keys like Imsak, Midnight — keep them if present.
//     final Map<String, String> prayerTimes = {};
//     timings.forEach((k, v) {
//       prayerTimes[k] = v.toString();
//     });
//
//     if (saveToBoxes) {
//       await _saveNamazTasks(date, prayerTimes);
//     }
//
//     return prayerTimes;
//   }
//
//   /// Save prayer times as TaskModel in Hive and Firestore (avoid duplicates using namazKey)
//   static Future<void> _saveNamazTasks(DateTime date, Map<String, String> prayerTimes) async {
//     final box = Hive.box<TaskModel>('tasks');
//     final firestore = FirebaseFirestore.instance;
//
//     // existing namaz keys to avoid duplicates
//     final existingKeys = box.values.where((t) => t.isNamaz && t.namazKey != null).map((t) => t.namazKey!).toSet();
//
//     for (final entry in prayerTimes.entries) {
//       final prayerName = entry.key; // e.g. "Fajr"
//       final timeStr = entry.value; // e.g. "06:06" or "06:06 (BST)" — we'll strip non-numeric
//
//       // parse time string HH:mm (strip any extra)
//       final timeParts = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
//       if (timeParts == null) continue;
//       final hour = int.parse(timeParts.group(1)!);
//       final minute = int.parse(timeParts.group(2)!);
//
//       // Build DateTime in local timezone with the provided date
//       final prayerDateTime = DateTime(date.year, date.month, date.day, hour, minute);
//
//       final key = "${date.toIso8601String().split('T')[0]}|$prayerName"; // 2025-01-01|Fajr
//
//       if (existingKeys.contains(key)) {
//         // already present — skip
//         continue;
//       }
//
//       // Create TaskModel
//       final task = TaskModel(
//         title: "$prayerName (Namaz)",
//         description: "Prayer time for $prayerName on ${date.toLocal().toIso8601String().split('T')[0]}",
//         priority: "Low",
//         date: date,
//         time: prayerDateTime,
//         reminder: false,
//         isNamaz: true,
//         namazKey: key,
//       );
//
//       // Save to Firebase first
//       try {
//         final docRef = await firestore.collection('tasks').add(task.toMap());
//         task.firebaseId = docRef.id;
//       } catch (e) {
//         // if firebase fails, we still save locally (offline friendly).
//       }
//
//       // Save locally to Hive
//       await box.add(task);
//     }
//   }
// }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:hive/hive.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/task_model.dart';
//
// class NamazService {
//   static const _base = 'https://api.aladhan.com/v1';
//
//   static Future<Map<String, String>?> fetchTimingsByAddress({
//     required DateTime date,
//     required String address,
//     String? apiKey7x,
//     int? method,
//     bool saveToBoxes = true,
//   }) async {
//     final dateStr =
//         "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
//     final params = {
//       'address': address,
//       if (apiKey7x != null) 'x7xapikey': apiKey7x,
//       if (method != null) 'method': method.toString(),
//       'iso8601': 'false',
//     };
//
//     final uri = Uri.parse('$_base/timingsByAddress/$dateStr')
//         .replace(queryParameters: params);
//
//     final res = await http.get(uri);
//     if (res.statusCode != 200) {
//       throw Exception('Failed to fetch namaz timings: ${res.statusCode}');
//     }
//
//     final body = jsonDecode(res.body) as Map<String, dynamic>;
//     if (body['code'] != 200 || body['data'] == null) {
//       throw Exception('Unexpected API response: ${res.body}');
//     }
//
//     final data = body['data'] as Map<String, dynamic>;
//     final timings = (data['timings'] as Map).cast<String, dynamic>();
//
//     final Map<String, String> prayerTimes = {};
//     timings.forEach((k, v) {
//       prayerTimes[k] = v.toString();
//     });
//
//     if (saveToBoxes) {
//       await _saveNamazTasks(date, prayerTimes);
//     }
//
//     return prayerTimes;
//   }
//
//   static Future<void> _saveNamazTasks(
//       DateTime date, Map<String, String> prayerTimes) async {
//     final box = Hive.box<TaskModel>('tasks');
//     final firestore = FirebaseFirestore.instance;
//
//     final existingKeys = box.values
//         .where((t) => t.isNamaz && t.namazKey != null)
//         .map((t) => t.namazKey!)
//         .toSet();
//
//     for (final entry in prayerTimes.entries) {
//       final prayerName = entry.key;
//       final timeStr = entry.value;
//
//       final timeParts = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
//       if (timeParts == null) continue;
//       final hour = int.parse(timeParts.group(1)!);
//       final minute = int.parse(timeParts.group(2)!);
//
//       final prayerDateTime =
//       DateTime(date.year, date.month, date.day, hour, minute);
//
//       final key = "${date.toIso8601String().split('T')[0]}|$prayerName";
//
//       if (existingKeys.contains(key)) continue;
//
//       final task = TaskModel(
//         title: "$prayerName (Namaz)",
//         description:
//         "Prayer time for $prayerName on ${date.toLocal().toIso8601String().split('T')[0]}",
//         priority: "Low",
//         date: date,
//         time: prayerDateTime,
//         reminder: false,
//         isNamaz: true,
//         namazKey: key,
//       );
//
//       try {
//         final docRef =
//         await firestore.collection('tasks').add(task.toMap());
//         task.firebaseId = docRef.id;
//       } catch (_) {}
//
//       await box.add(task);
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/task_model.dart';

class NamazService {
  static const _base = 'https://api.aladhan.com/v1';

  static Future<Map<String, String>?> fetchTimingsByAddress({
    required DateTime date,
    required String address,
    String? apiKey7x,
    int? method,
    bool saveToBoxes = true,
  }) async {
    final dateStr =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    final params = {
      'address': address,
      if (apiKey7x != null) 'x7xapikey': apiKey7x,
      if (method != null) 'method': method.toString(),
      'iso8601': 'false',
    };

    final uri = Uri.parse('$_base/timingsByAddress/$dateStr')
        .replace(queryParameters: params);

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch namaz timings: ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code'] != 200 || body['data'] == null) {
      throw Exception('Unexpected API response: ${res.body}');
    }

    final data = body['data'] as Map<String, dynamic>;
    final timings = (data['timings'] as Map).cast<String, dynamic>();

    final Map<String, String> prayerTimes = {};
    timings.forEach((k, v) {
      prayerTimes[k] = v.toString();
    });

    if (saveToBoxes) {
      await _saveNamazTasks(date, prayerTimes);
    }

    return prayerTimes;
  }

  static Future<void> _saveNamazTasks(
      DateTime date, Map<String, String> prayerTimes) async {
    final box = Hive.box<TaskModel>('tasks');
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final existingKeys = box.values
        .where((t) => t.isNamaz && t.namazKey != null)
        .map((t) => t.namazKey!)
        .toSet();

    for (final entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final timeStr = entry.value;

      final timeParts = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
      if (timeParts == null) continue;
      final hour = int.parse(timeParts.group(1)!);
      final minute = int.parse(timeParts.group(2)!);

      final prayerDateTime =
      DateTime(date.year, date.month, date.day, hour, minute);

      final key = "${date.toIso8601String().split('T')[0]}|$prayerName";

      if (existingKeys.contains(key)) continue;

      final task = TaskModel(
        title: "$prayerName (Namaz)",
        description:
        "Prayer time for $prayerName on ${date.toLocal().toIso8601String().split('T')[0]}",
        priority: "High",
        date: date,
        time: prayerDateTime,
        reminder: true,
        isNamaz: true,
        namazKey: key,
      );

      try {
        if (userId != null) {
          final docRef = await firestore.collection('tasks').add(
            task.toMap()..['userId'] = userId,
          );
          task.firebaseId = docRef.id;
        }
      } catch (e) {
        debugPrint('Error saving namaz to Firebase: $e');
      }

      await box.add(task);
    }
  }
}