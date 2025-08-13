// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// //
// // import 'model/task_model.dart';
// //
// // class CreateTaskScreen extends StatefulWidget {
// //   const CreateTaskScreen({super.key});
// //
// //   @override
// //   State<CreateTaskScreen> createState() => _CreateTaskScreenState();
// // }
// //
// // class _CreateTaskScreenState extends State<CreateTaskScreen> {
// //   final titleController = TextEditingController();
// //   final descController = TextEditingController();
// //   String priority = "Medium";
// //   DateTime selectedDate = DateTime.now();
// //   TimeOfDay selectedTime = TimeOfDay.now();
// //   bool reminder = false;
// //   bool _loading = false;
// //
// //   Future<void> _pickDate() async {
// //     DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2100),
// //     );
// //     if (picked != null) setState(() => selectedDate = picked);
// //   }
// //
// //   Future<void> _pickTime() async {
// //     TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: selectedTime,
// //     );
// //     if (picked != null) setState(() => selectedTime = picked);
// //   }
// //
// //   Future<void> _saveTask() async {
// //     if (titleController.text.trim().isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter a title')),
// //       );
// //       return;
// //     }
// //
// //     setState(() => _loading = true);
// //
// //     try {
// //       String? userId = FirebaseAuth.instance.currentUser?.uid;
// //
// //       final taskForFirebase = {
// //         'userId': userId, // store user id
// //         'title': titleController.text.trim(),
// //         'description': descController.text.trim(),
// //         'priority': priority,
// //         'date': selectedDate.toIso8601String(),
// //         'time': DateTime(
// //           selectedDate.year,
// //           selectedDate.month,
// //           selectedDate.day,
// //           selectedTime.hour,
// //           selectedTime.minute,
// //         ).toIso8601String(),
// //         'reminder': reminder,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };
// //
// //       // 1) Save to Firebase first
// //       final docRef = await FirebaseFirestore.instance
// //           .collection('tasks')
// //           .add(taskForFirebase);
// //
// //       // 2) Save locally to Hive
// //       final taskModel = TaskModel(
// //         title: titleController.text.trim(),
// //         description: descController.text.trim(),
// //         priority: priority,
// //         date: selectedDate,
// //         time: DateTime(
// //           selectedDate.year,
// //           selectedDate.month,
// //           selectedDate.day,
// //           selectedTime.hour,
// //           selectedTime.minute,
// //         ),
// //         reminder: reminder,
// //       );
// //
// //       final box = Hive.box<TaskModel>('tasks');
// //       await box.add(taskModel);
// //
// //       Navigator.pop(context);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to save task: $e')),
// //       );
// //     } finally {
// //       if (mounted) setState(() => _loading = false);
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     titleController.dispose();
// //     descController.dispose();
// //     super.dispose();
// //   }
// //
// //   String _formatDate(DateTime d) =>
// //       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
// //   String _formatTime(TimeOfDay t) =>
// //       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF003366),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF002244),
// //         title: const Text('Create Task'),
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 TextField(
// //                   controller: titleController,
// //                   decoration: const InputDecoration(
// //                     labelText: "Task Name",
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 TextField(
// //                   controller: descController,
// //                   maxLines: 3,
// //                   decoration: const InputDecoration(
// //                     labelText: "Description",
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 DropdownButtonFormField<String>(
// //                   value: priority,
// //                   items: ["Low", "Medium", "High"]
// //                       .map((p) =>
// //                       DropdownMenuItem(value: p, child: Text(p)))
// //                       .toList(),
// //                   onChanged: (val) =>
// //                       setState(() => priority = val ?? 'Medium'),
// //                   decoration: const InputDecoration(
// //                     labelText: "Priority",
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: ElevatedButton.icon(
// //                         icon: const Icon(Icons.calendar_today),
// //                         label: Text(_formatDate(selectedDate)),
// //                         onPressed: _pickDate,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: ElevatedButton.icon(
// //                         icon: const Icon(Icons.access_time),
// //                         label: Text(_formatTime(selectedTime)),
// //                         onPressed: _pickTime,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text(
// //                       "Reminder",
// //                       style: TextStyle(color: Colors.white, fontSize: 16),
// //                     ),
// //                     Switch(
// //                       value: reminder,
// //                       onChanged: (val) =>
// //                           setState(() => reminder = val),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: OutlinedButton(
// //                         child: const Text("Cancel"),
// //                         onPressed: () => Navigator.pop(context),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         child: _loading
// //                             ? const CircularProgressIndicator(
// //                             color: Colors.white)
// //                             : const Text("Create"),
// //                         onPressed: _loading ? null : _saveTask,
// //                       ),
// //                     ),
// //                   ],
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import 'model/task_model.dart';
//
// class CreateTaskScreen extends StatefulWidget {
//   final Function(String)? onCategorySelected;
//
//   const CreateTaskScreen({super.key, this.onCategorySelected});
//
//   @override
//   State<CreateTaskScreen> createState() => _CreateTaskScreenState();
// }
//
// class _CreateTaskScreenState extends State<CreateTaskScreen> {
//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   String priority = "Medium";
//   String category = "Event"; // Default category
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   bool reminder = false;
//   bool _loading = false;
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> _pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => selectedDate = picked);
//   }
//
//   Future<void> _pickTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null) setState(() => selectedTime = picked);
//   }
//
//   Future<void> _scheduleNotification(TaskModel task) async {
//     if (!task.reminder) return;
//
//     final scheduledTime = task.time.subtract(const Duration(minutes: 15));
//     if (scheduledTime.isBefore(DateTime.now())) return;
//
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'task_channel',
//       'Task Reminders',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.zonedSchedule(
//       task.title.hashCode,
//       task.title,
//       task.description,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//      // uiLocalNotificationDateInterpretation:
//      // UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   Future<void> _saveTask() async {
//     if (titleController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a title')),
//       );
//       return;
//     }
//
//     setState(() => _loading = true);
//
//     try {
//       String? userId = FirebaseAuth.instance.currentUser?.uid;
//
//       final taskModel = TaskModel(
//         title: titleController.text.trim(),
//         description: descController.text.trim(),
//         priority: priority,
//         date: selectedDate,
//         time: DateTime(
//           selectedDate.year,
//           selectedDate.month,
//           selectedDate.day,
//           selectedTime.hour,
//           selectedTime.minute,
//         ),
//         reminder: reminder,
//         category: category,
//       );
//
//       // Save to Firebase
//       final taskForFirebase = {
//         'userId': userId,
//         'title': taskModel.title,
//         'description': taskModel.description,
//         'priority': taskModel.priority,
//         'date': taskModel.date.toIso8601String(),
//         'time': taskModel.time.toIso8601String(),
//         'reminder': taskModel.reminder,
//         'category': taskModel.category,
//         'createdAt': FieldValue.serverTimestamp(),
//       };
//
//       final docRef = await FirebaseFirestore.instance
//           .collection('tasks')
//           .add(taskForFirebase);
//       taskModel.firebaseId = docRef.id;
//
//       // Save locally to Hive
//       final box = Hive.box<TaskModel>('tasks');
//       await box.add(taskModel);
//
//       // Schedule notification
//       await _scheduleNotification(taskModel);
//
//       widget.onCategorySelected?.call(category);
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save task: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     descController.dispose();
//     super.dispose();
//   }
//
//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//   String _formatTime(TimeOfDay t) =>
//       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF003366),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF002244),
//         title: const Text('Create Task'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                     labelText: "Task Name",
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: descController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     labelText: "Description",
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: priority,
//                   items: ["Low", "Medium", "High"]
//                       .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//                       .toList(),
//                   onChanged: (val) => setState(() => priority = val ?? 'Medium'),
//                   decoration: const InputDecoration(
//                     labelText: "Priority",
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: category,
//                   items: ["Event", "ClientMeeting", "Project"]
//                       .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//                       .toList(),
//                   onChanged: (val) => setState(() => category = val ?? 'Event'),
//                   decoration: const InputDecoration(
//                     labelText: "Category",
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.calendar_today),
//                         label: Text(_formatDate(selectedDate)),
//                         onPressed: _pickDate,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.access_time),
//                         label: Text(_formatTime(selectedTime)),
//                         onPressed: _pickTime,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Reminder",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     Switch(
//                       value: reminder,
//                       onChanged: (val) => setState(() => reminder = val),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         child: const Text("Cancel"),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         child: _loading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text("Create"),
//                         onPressed: _loading ? null : _saveTask,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'model/task_model.dart';

class CreateTaskScreen extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const CreateTaskScreen({super.key, this.onCategorySelected});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String priority = "Medium";
  String category = "Event";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool reminder = false;
  bool _loading = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Category options with icons
  final List<Map<String, dynamic>> categories = [
    {'name': 'Event', 'icon': Icons.event, 'color': Colors.blue},
    {'name': 'Meeting', 'icon': Icons.people, 'color': Colors.green},
    {'name': 'Project', 'icon': Icons.work, 'color': Colors.orange},
    {'name': 'Personal', 'icon': Icons.person, 'color': Colors.purple},
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _scheduleNotification(TaskModel task) async {
    if (!task.reminder) return;

    final scheduledTime = task.time.subtract(const Duration(minutes: 15));
    if (scheduledTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      importance: Importance.high,
      priority: Priority.high,
      channelDescription: 'Notifications for task reminders',
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      task.title.hashCode,
      'Reminder: ${task.title}',
      task.description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final taskTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final taskModel = TaskModel(
        title: titleController.text.trim(),
        description: descController.text.trim(),
        priority: priority,
        date: selectedDate,
        time: taskTime,
        reminder: reminder,
        category: category,
      );

      // Save to Firebase
      final docRef = await FirebaseFirestore.instance
          .collection('tasks')
          .add(taskModel.toMap()..['userId'] = userId);

      taskModel.firebaseId = docRef.id;

      // Save locally to Hive
      final box = Hive.box<TaskModel>('tasks');
      await box.add(taskModel);

      // Schedule notification
      await _scheduleNotification(taskModel);

      widget.onCategorySelected?.call(category);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);
  String _formatTime(TimeOfDay t) => t.format(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D47A1),
      appBar: AppBar(
        title: const Text('Create Task', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D47A1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: ["Low", "Medium", "High"]
                        .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => priority = val ?? 'Medium'),
                    decoration: InputDecoration(
                      labelText: "Priority",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: categories
                        .map((c) => DropdownMenuItem<String>(
                      value: c['name'],
                      child: Row(
                        children: [
                          Icon(c['icon'], color: c['color']),
                          const SizedBox(width: 8),
                          Text(c['name']),
                        ],
                      ),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => category = val ?? 'Event'),
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_formatDate(selectedDate)),
                          onPressed: _pickDate,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(_formatTime(selectedTime)),
                          onPressed: _pickTime,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text("Set Reminder"),
                    value: reminder,
                    onChanged: (val) => setState(() => reminder = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _saveTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Create Task",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
