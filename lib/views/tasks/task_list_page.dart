// // import 'package:flutter/material.dart';
// // import 'package:hive_flutter/hive_flutter.dart';
// // import 'package:hive/hive.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import 'domain/namaz_service.dart';
// // import 'model/task_model.dart';
// // import 'create_task_page.dart';
// // import 'update_task_screen.dart';
// //
// // class TasksListScreen extends StatefulWidget {
// //   const TasksListScreen({super.key});
// //
// //   @override
// //   State<TasksListScreen> createState() => _TasksListScreenState();
// // }
// //
// // class _TasksListScreenState extends State<TasksListScreen> {
// //   final searchController = TextEditingController();
// //   late Box<TaskModel> taskBox;
// //   bool _loadingNamaz = false;
// //   String? _savedLocation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     taskBox = Hive.box<TaskModel>('tasks');
// //     _initLocationAndFetch();
// //   }
// //
// //   Future<void> _initLocationAndFetch() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? location = prefs.getString('user_location');
// //
// //     if (location == null || location.isEmpty) {
// //       await _askForLocation();
// //     } else {
// //       _savedLocation = location;
// //       await _fetchNamazTimes(location);
// //     }
// //   }
// //
// //   Future<void> _askForLocation() async {
// //     final controller = TextEditingController();
// //
// //     String? result = await showDialog<String>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text("Enter Your City & Country"),
// //           content: TextField(
// //             controller: controller,
// //             decoration: const InputDecoration(
// //               hintText: "e.g. Karachi, Pakistan",
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context, controller.text.trim());
// //               },
// //               child: const Text("OK"),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //
// //     if (result != null && result.isNotEmpty) {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('user_location', result);
// //       _savedLocation = result;
// //       await _fetchNamazTimes(result);
// //     }
// //   }
// //
// //   Future<void> _fetchNamazTimes(String address) async {
// //     setState(() => _loadingNamaz = true);
// //     try {
// //       await NamazService.fetchTimingsByAddress(
// //         date: DateTime.now(),
// //         address: address,
// //         method: 2,
// //       );
// //     } catch (e) {
// //       debugPrint("Error fetching Namaz times: $e");
// //     }
// //     setState(() => _loadingNamaz = false);
// //   }
// //
// //   String _formatDate(DateTime d) =>
// //       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
// //
// //   String _formatTime(DateTime t) =>
// //       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF003366),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF206AD1),
// //         title: const Text('Tasks & Namaz Times', style: TextStyle(color: Colors.white)),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.edit_location_alt, color: Colors.white),
// //             tooltip: "Change Location",
// //             onPressed: _askForLocation,
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.refresh, color: Colors.white),
// //             onPressed: () {
// //               if (_savedLocation != null) {
// //                 _fetchNamazTimes(_savedLocation!);
// //               }
// //             },
// //           )
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Search bar
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: searchController,
// //                       style: const TextStyle(color: Colors.white),
// //                       decoration: InputDecoration(
// //                         hintText: "Search by task title",
// //                         hintStyle: const TextStyle(color: Colors.white54),
// //                         filled: true,
// //                         fillColor: const Color(0xFF0055AA),
// //                         prefixIcon: const Icon(Icons.search, color: Colors.white),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                       ),
// //                       onChanged: (_) => setState(() {}),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),
// //               const Text(
// //                 "Tasks List",
// //                 style: TextStyle(
// //                     color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 10),
// //               Expanded(
// //                 child: ValueListenableBuilder(
// //                   valueListenable: taskBox.listenable(),
// //                   builder: (context, Box<TaskModel> box, _) {
// //                     final query = searchController.text.trim().toLowerCase();
// //                     final items = box.values.toList();
// //                     final filtered = query.isEmpty
// //                         ? items
// //                         : items.where((t) => t.title.toLowerCase().contains(query)).toList();
// //
// //                     if (_loadingNamaz) {
// //                       return const Center(
// //                         child: CircularProgressIndicator(color: Colors.white),
// //                       );
// //                     }
// //
// //                     if (filtered.isEmpty) {
// //                       return const Center(
// //                         child: Text(
// //                           "No tasks yet",
// //                           style: TextStyle(color: Colors.white70),
// //                         ),
// //                       );
// //                     }
// //
// //                     return ListView.builder(
// //                       itemCount: filtered.length,
// //                       itemBuilder: (context, idx) {
// //                         final task = filtered[idx];
// //                         final hiveIndex = box.values.toList().indexOf(task);
// //
// //                         return Card(
// //                           color: task.isNamaz
// //                               ? Colors.lightBlue.withOpacity(0.15)
// //                               : const Color(0xFF004080),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: ListTile(
// //                             leading: Icon(
// //                               task.isNamaz ? Icons.mosque : Icons.check_circle,
// //                               color: Colors.white,
// //                             ),
// //                             title: Text(
// //                               task.title,
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: task.isNamaz
// //                                     ? FontWeight.bold
// //                                     : FontWeight.normal,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               "${_formatDate(task.date)} • ${_formatTime(task.time)}",
// //                               style: const TextStyle(color: Colors.white70),
// //                             ),
// //                             trailing: const Icon(Icons.arrow_forward_ios,
// //                                 size: 18, color: Colors.white70),
// //                             onTap: () {
// //                               if (!task.isNamaz) {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (_) => UpdateTaskScreen(
// //                                       hiveIndex: hiveIndex,
// //                                     ),
// //                                   ),
// //                                 );
// //                               }
// //                             },
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Colors.lightBlue,
// //         child: const Icon(Icons.add, color: Colors.white),
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../core/theme/app_colors.dart';
// import 'domain/namaz_service.dart';
// import 'model/task_model.dart';
// import 'create_task_page.dart';
// import 'update_task_screen.dart';
//
// class TasksListScreen extends StatefulWidget {
//   const TasksListScreen({super.key});
//
//   @override
//   State<TasksListScreen> createState() => _TasksListScreenState();
// }
//
// class _TasksListScreenState extends State<TasksListScreen> {
//   final searchController = TextEditingController();
//   late Box<TaskModel> taskBox;
//   bool _loadingNamaz = false;
//   String? _savedLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     taskBox = Hive.box<TaskModel>('tasks');
//     _initLocationAndFetch();
//   }
//
//   Future<void> _initLocationAndFetch() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? location = prefs.getString('user_location');
//
//     if (location == null || location.isEmpty) {
//       await _askForLocation();
//     } else {
//       _savedLocation = location;
//       await _fetchNamazTimes(location);
//     }
//   }
//
//   Future<void> _askForLocation() async {
//     final controller = TextEditingController();
//
//     String? result = await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Enter Your City & Country"),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: "e.g. Karachi, Pakistan",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, controller.text.trim());
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (result != null && result.isNotEmpty) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_location', result);
//       _savedLocation = result;
//       await _fetchNamazTimes(result);
//     }
//   }
//
//   Future<void> _fetchNamazTimes(String address) async {
//     setState(() => _loadingNamaz = true);
//     try {
//       await NamazService.fetchTimingsByAddress(
//         date: DateTime.now(),
//         address: address,
//         method: 2,
//       );
//     } catch (e) {
//       debugPrint("Error fetching Namaz times: $e");
//     }
//     setState(() => _loadingNamaz = false);
//   }
//
//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//
//   String _formatTime(DateTime t) =>
//       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Text('Tasks & Namaz Times', style: TextStyle(color: AppColors.textWhite)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit_location_alt, color: AppColors.textWhite),
//             tooltip: "Change Location",
//             onPressed: _askForLocation,
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh, color: AppColors.textWhite),
//             onPressed: () {
//               if (_savedLocation != null) {
//                 _fetchNamazTimes(_savedLocation!);
//               }
//             },
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: searchController,
//                       style: TextStyle(color: AppColors.textWhite),
//                       decoration: InputDecoration(
//                         hintText: "Search by task title",
//                         hintStyle: TextStyle(color: AppColors.textWhite70),
//                         filled: true,
//                         fillColor: AppColors.primaryLight,
//                         prefixIcon: Icon(Icons.search, color: AppColors.textWhite),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       onChanged: (_) => setState(() {}),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Tasks List",
//                 style: TextStyle(
//                     color: AppColors.textWhite,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: ValueListenableBuilder(
//                   valueListenable: taskBox.listenable(),
//                   builder: (context, Box<TaskModel> box, _) {
//                     final query = searchController.text.trim().toLowerCase();
//                     final items = box.values.toList();
//                     final filtered = query.isEmpty
//                         ? items
//                         : items.where((t) => t.title.toLowerCase().contains(query)).toList();
//
//                     if (_loadingNamaz) {
//                       return Center(
//                         child: CircularProgressIndicator(color: AppColors.textWhite),
//                       );
//                     }
//
//                     if (filtered.isEmpty) {
//                       return Center(
//                         child: Text(
//                           "No tasks yet",
//                           style: TextStyle(color: AppColors.textWhite70),
//                         ),
//                       );
//                     }
//
//                     return ListView.builder(
//                       itemCount: filtered.length,
//                       itemBuilder: (context, idx) {
//                         final task = filtered[idx];
//                         final hiveIndex = box.values.toList().indexOf(task);
//
//                         return Card(
//                           color: task.isNamaz
//                               ? AppColors.primaryLight.withOpacity(0.15)
//                               : AppColors.primaryDark,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               task.isNamaz ? Icons.mosque : Icons.check_circle,
//                               color: AppColors.textWhite,
//                             ),
//                             title: Text(
//                               task.title,
//                               style: TextStyle(
//                                 color: AppColors.textWhite,
//                                 fontWeight: task.isNamaz
//                                     ? FontWeight.bold
//                                     : FontWeight.normal,
//                               ),
//                             ),
//                             subtitle: Text(
//                               "${_formatDate(task.date)} • ${_formatTime(task.time)}",
//                               style: TextStyle(color: AppColors.textWhite70),
//                             ),
//                             trailing: Icon(Icons.arrow_forward_ios,
//                                 size: 18, color: AppColors.textWhite70),
//                             onTap: () {
//                               if (!task.isNamaz) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => UpdateTaskScreen(
//                                       hiveIndex: hiveIndex,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.accent,
//         child: Icon(Icons.add, color: AppColors.textWhite),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import '../../core/theme/app_colors.dart';
// import 'domain/namaz_service.dart';
// import 'model/task_model.dart';
// import 'create_task_page.dart';
// import 'update_task_screen.dart';
//
// enum TaskCategory { Prayer, Event, ClientMeeting, Project }
//
// class TasksListScreen extends StatefulWidget {
//   const TasksListScreen({super.key});
//
//   @override
//   State<TasksListScreen> createState() => _TasksListScreenState();
// }
//
// class _TasksListScreenState extends State<TasksListScreen> {
//   final searchController = TextEditingController();
//   late Box<TaskModel> taskBox;
//   bool _loadingNamaz = false;
//   String? _savedLocation;
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     taskBox = Hive.box<TaskModel>('tasks');
//     _initLocationAndFetch();
//     _initNotifications();
//     _syncTasksWithFirebase();
//   }
//
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     await _notificationsPlugin.initialize(initializationSettings);
//
//     // Request notification permissions
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
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
//       task.namazKey?.hashCode ?? task.title.hashCode,
//       task.title,
//       task.description,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       //uiLocalNotificationDateInterpretation:
//      // UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   Future<void> _initLocationAndFetch() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? location = prefs.getString('user_location');
//
//     if (location == null || location.isEmpty) {
//       await _askForLocation();
//     } else {
//       _savedLocation = location;
//       await _fetchNamazTimes(location);
//     }
//   }
//
//   Future<void> _askForLocation() async {
//     final controller = TextEditingController();
//
//     String? result = await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Enter Your City & Country"),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: "e.g. Karachi, Pakistan",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, controller.text.trim());
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (result != null && result.isNotEmpty) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_location', result);
//       _savedLocation = result;
//       await _fetchNamazTimes(result);
//     }
//   }
//
//   Future<void> _fetchNamazTimes(String address) async {
//     setState(() => _loadingNamaz = true);
//     try {
//       final timings = await NamazService.fetchTimingsByAddress(
//         date: DateTime.now(),
//         address: address,
//         method: 2,
//       );
//       if (timings != null) {
//         for (var task in taskBox.values.where((t) => t.isNamaz)) {
//           _scheduleNotification(task);
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching Namaz times: $e");
//     }
//     setState(() => _loadingNamaz = false);
//   }
//
//   Future<void> _syncTasksWithFirebase() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('tasks')
//         .where('userId', isEqualTo: userId)
//         .get();
//
//     for (var doc in snapshot.docs) {
//       final task = TaskModel.fromMap(doc.data())..firebaseId = doc.id;
//       final existingTask = taskBox.values.firstWhere(
//             (t) => t.firebaseId == task.firebaseId,
//         orElse: () => task,
//       );
//       if (existingTask.firebaseId == null) {
//         await taskBox.add(task);
//         _scheduleNotification(task);
//       }
//     }
//   }
//
//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//
//   String _formatTime(DateTime t) =>
//       "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//
//   bool _isTaskUpcoming(TaskModel task) {
//     if (task.isNamaz) {
//       final now = DateTime.now();
//       final oneHourBefore = task.time.subtract(const Duration(hours: 1));
//       return now.isAfter(oneHourBefore) && now.isBefore(task.time);
//     }
//     return task.time.isAfter(DateTime.now());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Text('Tasks & Namaz Times', style: TextStyle(color: AppColors.textWhite)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit_location_alt, color: AppColors.textWhite),
//             tooltip: "Change Location",
//             onPressed: _askForLocation,
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh, color: AppColors.textWhite),
//             onPressed: () {
//               if (_savedLocation != null) {
//                 _fetchNamazTimes(_savedLocation!);
//               }
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: searchController,
//                 style: TextStyle(color: AppColors.textWhite),
//                 decoration: InputDecoration(
//                   hintText: "Search by task title",
//                   hintStyle: TextStyle(color: AppColors.textWhite70),
//                   filled: true,
//                   fillColor: AppColors.primaryLight,
//                   prefixIcon: Icon(Icons.search, color: AppColors.textWhite),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 onChanged: (_) => setState(() {}),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ValueListenableBuilder(
//                   valueListenable: taskBox.listenable(),
//                   builder: (context, Box<TaskModel> box, _) {
//                     final query = searchController.text.trim().toLowerCase();
//                     final items = box.values.toList();
//                     final filtered = query.isEmpty
//                         ? items
//                         : items.where((t) => t.title.toLowerCase().contains(query)).toList();
//
//                     if (_loadingNamaz) {
//                       return Center(
//                         child: CircularProgressIndicator(color: AppColors.textWhite),
//                       );
//                     }
//
//                     if (filtered.isEmpty) {
//                       return Center(
//                         child: Text(
//                           "No tasks yet",
//                           style: TextStyle(color: AppColors.textWhite70),
//                         ),
//                       );
//                     }
//
//                     final categories = {
//                       TaskCategory.Prayer: filtered.where((t) => t.isNamaz).toList(),
//                       TaskCategory.Event: filtered.where((t) => t.category == 'Event').toList(),
//                       TaskCategory.ClientMeeting:
//                       filtered.where((t) => t.category == 'ClientMeeting').toList(),
//                       TaskCategory.Project: filtered.where((t) => t.category == 'Project').toList(),
//                     };
//
//                     return ListView(
//                       children: categories.entries.map((entry) {
//                         final categoryTasks = entry.value;
//                         if (categoryTasks.isEmpty) return const SizedBox.shrink();
//
//                         final upcoming = categoryTasks.where(_isTaskUpcoming).toList();
//                         final completed = categoryTasks.where((t) => !_isTaskUpcoming(t)).toList();
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               entry.key.toString().split('.').last,
//                               style: TextStyle(
//                                 color: AppColors.textWhite,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             if (upcoming.isNotEmpty) ...[
//                               Text(
//                                 "Upcoming",
//                                 style: TextStyle(
//                                   color: AppColors.textWhite70,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               ...upcoming.map((task) => _buildTaskTile(task, box)),
//                             ],
//                             if (completed.isNotEmpty) ...[
//                               const SizedBox(height: 10),
//                               Text(
//                                 "Completed",
//                                 style: TextStyle(
//                                   color: AppColors.textWhite70,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               ...completed.map((task) => _buildTaskTile(task, box)),
//                             ],
//                             const SizedBox(height: 20),
//                           ],
//                         );
//                       }).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.accent,
//         child: Icon(Icons.add, color: AppColors.textWhite),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CreateTaskScreen(
//                 onCategorySelected: (category) {
//                   // Handle category selection if needed
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTaskTile(TaskModel task, Box<TaskModel> box) {
//     final hiveIndex = box.values.toList().indexOf(task);
//     return Card(
//       color: task.isNamaz
//           ? AppColors.primaryLight.withOpacity(0.15)
//           : AppColors.primaryDark,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Icon(
//           task.isNamaz ? Icons.mosque : Icons.check_circle,
//           color: AppColors.textWhite,
//         ),
//         title: Text(
//           task.title,
//           style: TextStyle(
//             color: AppColors.textWhite,
//             fontWeight: task.isNamaz ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         subtitle: Text(
//           "${_formatDate(task.date)} • ${_formatTime(task.time)}",
//           style: TextStyle(color: AppColors.textWhite70),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios,
//             size: 18, color: AppColors.textWhite70),
//         onTap: () {
//           if (!task.isNamaz) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => UpdateTaskScreen(
//                   hiveIndex: hiveIndex,
//                   firebaseId: task.firebaseId,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//}
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import 'create_task_page.dart';
import 'domain/namaz_service.dart';
import 'model/task_model.dart';
import 'update_task_screen.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  final searchController = TextEditingController();
  late Box<TaskModel> taskBox;
  bool _loadingNamaz = false;
  String? _savedLocation;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String _selectedCategory = 'All';

  final Map<String, Map<String, dynamic>> categoryData = {
    'All': {'color': Colors.blue, 'icon': Icons.list},
    'Event': {'color': Colors.blue, 'icon': Icons.event},
    'Meeting': {'color': Colors.green, 'icon': Icons.people},
    'Project': {'color': Colors.orange, 'icon': Icons.work},
    'Personal': {'color': Colors.purple, 'icon': Icons.person},
    'Namaz': {'color': Colors.teal, 'icon': Icons.mosque},
  };

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<TaskModel>('tasks');
    _initLocationAndFetch();
    _initNotifications();
    _syncTasksWithFirebase();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _scheduleNotification(TaskModel task) async {
    if (!task.reminder) return;

    final scheduledTime = task.time.subtract(const Duration(minutes: 15));
    if (scheduledTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      task.namazKey?.hashCode ?? task.title.hashCode,
      'Reminder: ${task.title}',
      task.description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _initLocationAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('user_location');

    if (location == null || location.isEmpty) {
      await _askForLocation();
    } else {
      _savedLocation = location;
      await _fetchNamazTimes(location);
    }
  }

  Future<void> _askForLocation() async {
    final controller = TextEditingController();

    String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Your City & Country"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "e.g. Karachi, Pakistan",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_location', result);
      _savedLocation = result;
      await _fetchNamazTimes(result);
    }
  }

  Future<void> _fetchNamazTimes(String address) async {
    setState(() => _loadingNamaz = true);
    try {
      final timings = await NamazService.fetchTimingsByAddress(
        date: DateTime.now(),
        address: address,
        method: 2,
      );
      if (timings != null) {
        for (var task in taskBox.values.where((t) => t.isNamaz)) {
          _scheduleNotification(task);
        }
      }
    } catch (e) {
      debugPrint("Error fetching Namaz times: $e");
    }
    setState(() => _loadingNamaz = false);
  }

  Future<void> _syncTasksWithFirebase() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data())..firebaseId = doc.id;
      final existingTask = taskBox.values.firstWhere(
            (t) => t.firebaseId == task.firebaseId,
        orElse: () => task,
      );
      if (existingTask.firebaseId == null) {
        await taskBox.add(task);
        _scheduleNotification(task);
      }
    }
  }

  String _formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);
  String _formatTime(DateTime t) => DateFormat('h:mm a').format(t);

  bool _isTaskUpcoming(TaskModel task) {
    if (task.isNamaz) {
      final now = DateTime.now();
      final oneHourBefore = task.time.subtract(const Duration(hours: 1));
      return now.isAfter(oneHourBefore) && now.isBefore(task.time);
    }
    return task.time.isAfter(DateTime.now());
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryData.entries.map((entry) {
          final category = entry.key;
          final data = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : 'All';
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: data['color'].withOpacity(0.2),
              labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? data['color']
                    : Colors.black,
                fontWeight: _selectedCategory == category
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              avatar: Icon(data['icon'], color: data['color']),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_location_alt),
            tooltip: "Change Location",
            onPressed: _askForLocation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_savedLocation != null) {
                _fetchNamazTimes(_savedLocation!);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildCategoryChips(),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: taskBox.listenable(),
                  builder: (context, Box<TaskModel> box, _) {
                    final query = searchController.text.trim().toLowerCase();
                    var items = box.values.toList();

                    if (query.isNotEmpty) {
                      items = items
                          .where((t) =>
                      t.title.toLowerCase().contains(query) ||
                          t.description.toLowerCase().contains(query))
                          .toList();
                    }

                    if (_selectedCategory != 'All') {
                      items = items
                          .where((t) => _selectedCategory == 'Namaz'
                          ? t.isNamaz
                          : t.category == _selectedCategory)
                          .toList();
                    }

                    if (_loadingNamaz) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "No tasks found",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    final upcoming =
                    items.where(_isTaskUpcoming).toList();
                    final completed =
                    items.where((t) => !_isTaskUpcoming(t)).toList();

                    return ListView(
                      children: [
                        if (upcoming.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Upcoming Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...upcoming.map((task) => _buildTaskTile(task, box)),
                        ],
                        if (completed.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Completed Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: Colors.white
                              ),
                            ),
                          ),
                          ...completed.map((task) => _buildTaskTile(task, box)),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTaskScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskTile(TaskModel task, Box<TaskModel> box) {
    final hiveIndex = box.values.toList().indexOf(task);
    final categoryInfo =
        categoryData[task.isNamaz ? 'Namaz' : task.category] ??
            categoryData['Event']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryInfo['color'].withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(categoryInfo['icon'], color: categoryInfo['color']),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
            task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(task.date)} • ${_formatTime(task.time)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: task.isNamaz
            ? null
            : IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showTaskOptions(context, task, hiveIndex);
          },
        ),
        onTap: () {
          if (!task.isNamaz) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateTaskScreen(
                  hiveIndex: hiveIndex,
                  firebaseId: task.firebaseId,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showTaskOptions(BuildContext context, TaskModel task, int hiveIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTaskScreen(
                      hiveIndex: hiveIndex,
                      firebaseId: task.firebaseId,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                task.isCompleted ? Icons.undo : Icons.check_circle,
                color: task.isCompleted ? Colors.blue : Colors.green,
              ),
              title: Text(task.isCompleted
                  ? 'Mark as Incomplete'
                  : 'Mark as Complete'),
              onTap: () async {
                Navigator.pop(context);
                await _toggleTaskCompletion(task, hiveIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Task'),
              onTap: () async {
                Navigator.pop(context);
                await _confirmDeleteTask(context, task, hiveIndex);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleTaskCompletion(TaskModel task, int hiveIndex) async {
    final updatedTask = TaskModel(
      title: task.title,
      description: task.description,
      priority: task.priority,
      date: task.date,
      time: task.time,
      reminder: task.reminder,
      isCompleted: !task.isCompleted,
      category: task.category,
      isNamaz: task.isNamaz,
      namazKey: task.namazKey,
      firebaseId: task.firebaseId,
    );

    try {
      if (task.firebaseId != null && task.firebaseId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.firebaseId)
            .update({'isCompleted': updatedTask.isCompleted});
      }

      await taskBox.putAt(hiveIndex, updatedTask);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeleteTask(
      BuildContext context, TaskModel task, int hiveIndex) async {
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

    if (confirmed == true) {
      await _deleteTask(task, hiveIndex);
    }
  }

  Future<void> _deleteTask(TaskModel task, int hiveIndex) async {
    try {
      if (task.firebaseId != null && task.firebaseId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.firebaseId)
            .delete();
      }

      if (hiveIndex < taskBox.length) {
        await taskBox.deleteAt(hiveIndex);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
      }
    }
  }
}