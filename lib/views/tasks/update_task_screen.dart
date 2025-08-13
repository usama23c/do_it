// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
//
// import 'model/task_model.dart';
//
// class UpdateTaskScreen extends StatefulWidget {
//   final int hiveIndex;
//   final String? firebaseId;
//
//   const UpdateTaskScreen({
//     super.key,
//     required this.hiveIndex,
//     this.firebaseId,
//   });
//
//   @override
//   State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
// }
//
// class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   String priority = "Medium";
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   bool reminder = false;
//   late Box<TaskModel> taskBox;
//   bool _loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     taskBox = Hive.box<TaskModel>('tasks');
//
//     final task = taskBox.getAt(widget.hiveIndex);
//     if (task != null) {
//       titleController.text = task.title;
//       descController.text = task.description;
//       priority = task.priority;
//       selectedDate = task.date;
//       selectedTime = TimeOfDay.fromDateTime(task.time);
//       reminder = task.reminder;
//     } else {
//       debugPrint("No task found at index ${widget.hiveIndex}");
//     }
//   }
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
//   Future<void> _updateTask() async {
//     setState(() => _loading = true);
//
//     final updatedTask = TaskModel(
//       title: titleController.text.trim(),
//       description: descController.text.trim(),
//       priority: priority,
//       date: selectedDate,
//       time: DateTime(
//         selectedDate.year,
//         selectedDate.month,
//         selectedDate.day,
//         selectedTime.hour,
//         selectedTime.minute,
//       ),
//       reminder: reminder,
//     );
//
//     try {
//       // Update in Firebase if we have an ID
//       if (widget.firebaseId != null && widget.firebaseId!.isNotEmpty) {
//         await FirebaseFirestore.instance
//             .collection('tasks')
//             .doc(widget.firebaseId)
//             .update(updatedTask.toMap());
//       }
//
//       // Update in Hive
//       await taskBox.putAt(widget.hiveIndex, updatedTask);
//
//       if (mounted) Navigator.pop(context);
//     } catch (e, st) {
//       debugPrint("Update error: $e\n$st");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   Future<void> _deleteTask() async {
//     setState(() => _loading = true);
//
//     try {
//       // Delete from Firebase if ID exists
//       if (widget.firebaseId != null && widget.firebaseId!.isNotEmpty) {
//         await FirebaseFirestore.instance
//             .collection('tasks')
//             .doc(widget.firebaseId)
//             .delete();
//       }
//
//       // Delete from Hive safely
//       if (widget.hiveIndex < taskBox.length) {
//         await taskBox.deleteAt(widget.hiveIndex);
//       }
//
//       if (mounted) Navigator.pop(context);
//     } catch (e, st) {
//       debugPrint("Delete error: $e\n$st");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }
//
//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//
//   String _formatTime(TimeOfDay t) =>
//       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     descController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF003366),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF002244),
//         title: const Text("Update Task"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.redAccent),
//             onPressed: _loading
//                 ? null
//                 : () async {
//               final confirmed = await showDialog<bool>(
//                 context: context,
//                 builder: (_) => AlertDialog(
//                   title: const Text('Delete task?'),
//                   content: const Text('Are you sure you want to delete this task?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       child: const Text('Delete'),
//                     ),
//                   ],
//                 ),
//               );
//               if (confirmed == true) _deleteTask();
//             },
//           )
//         ],
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
//                       child: ElevatedButton(
//                         child: _loading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text("Update"),
//                         onPressed: _loading ? null : _updateTask,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'model/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final int hiveIndex;
  final String? firebaseId;

  const UpdateTaskScreen({
    super.key,
    required this.hiveIndex,
    this.firebaseId,
  });

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String priority = "Medium";
  String category = "Event";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool reminder = false;
  late Box<TaskModel> taskBox;
  bool _loading = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<TaskModel>('tasks');

    final task = taskBox.getAt(widget.hiveIndex);
    if (task != null) {
      titleController.text = task.title;
      descController.text = task.description;
      priority = task.priority;
      category = task.category ?? "Event";
      selectedDate = task.date;
      selectedTime = TimeOfDay.fromDateTime(task.time);
      reminder = task.reminder;
    } else {
      debugPrint("No task found at index ${widget.hiveIndex}");
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
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
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      task.title.hashCode,
      task.title,
      task.description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //  uiLocalNotificationDateInterpretation:
   //   UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _updateTask() async {
    setState(() => _loading = true);

    final updatedTask = TaskModel(
      title: titleController.text.trim(),
      description: descController.text.trim(),
      priority: priority,
      date: selectedDate,
      time: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      reminder: reminder,
      firebaseId: widget.firebaseId,
      category: category,
    );

    try {
      if (widget.firebaseId != null && widget.firebaseId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.firebaseId)
            .update(updatedTask.toMap());
      }

      await taskBox.putAt(widget.hiveIndex, updatedTask);
      await _scheduleNotification(updatedTask);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteTask() async {
    setState(() => _loading = true);

    try {
      if (widget.firebaseId != null && widget.firebaseId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.firebaseId)
            .delete();
      }

      if (widget.hiveIndex < taskBox.length) {
        await taskBox.deleteAt(widget.hiveIndex);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002244),
        title: const Text("Update Task"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _loading
                ? null
                : () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete task?'),
                  content: const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) _deleteTask();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Task Name",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: ["Low", "Medium", "High"]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => priority = val ?? 'Medium'),
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: category,
                  items: ["Event", "ClientMeeting", "Project"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => category = val ?? 'Event'),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_formatDate(selectedDate)),
                        onPressed: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(_formatTime(selectedTime)),
                        onPressed: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Reminder",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Switch(
                      value: reminder,
                      onChanged: (val) => setState(() => reminder = val),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: _loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Update"),
                        onPressed: _loading ? null : _updateTask,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
