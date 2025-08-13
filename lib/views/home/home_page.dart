import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../tasks/model/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Welcome";
  String userEmail = "";
  String userId = "";
  bool loading = true;
  List<TaskModel> allTasks = [];
  List<TaskModel> upcomingTasks = [];
  List<TaskModel> completedTasks = [];
  List<TaskModel> groupTasks = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadTasks();
  }

  Future<void> _getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        userEmail = user.email ?? "";

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          userName = data['name']?.toString() ?? userName;
        }
      }
    } catch (e) {
      debugPrint("Error getting user data: $e");
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _loadTasks() async {
    try {
      List<TaskModel> loadedTasks = [];

      // Load from Hive
      final box = Hive.box<TaskModel>('tasks');
      loadedTasks.addAll(box.values.toList());

      // Load from Firebase
      if (userId.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('userId', isEqualTo: userId)
            .get();

        loadedTasks.addAll(snapshot.docs.map((doc) {
          final task = TaskModel.fromMap(doc.data());
          task.firebaseId = doc.id;
          return task;
        }));
      }

      // Remove duplicates
      final uniqueTasks = <String, TaskModel>{};
      for (var task in loadedTasks) {
        if (task.firebaseId != null) {
          uniqueTasks[task.firebaseId!] = task;
        } else {
          uniqueTasks['${task.title}-${task.time.millisecondsSinceEpoch}'] = task;
        }
      }

      // Sort by time (ascending)
      allTasks = uniqueTasks.values.toList();
      allTasks.sort((a, b) => a.time.compareTo(b.time));

      final now = DateTime.now();

      setState(() {
        upcomingTasks = allTasks.where((task) => !task.isCompleted && task.time.isAfter(now)).toList();
        completedTasks = allTasks.where((task) => task.isCompleted || task.time.isBefore(now)).toList();
        groupTasks = upcomingTasks.take(3).toList();
      });

      debugPrint("Loaded ${allTasks.length} tasks total");
      debugPrint("Upcoming tasks: ${upcomingTasks.length}");
      debugPrint("Completed tasks: ${completedTasks.length}");
    } catch (e) {
      debugPrint("Error loading tasks: $e");
    }
  }

  String _formatTaskTime(DateTime time) {
    return DateFormat('EEEE | h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: SafeArea(
        child: loading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none,
                          size: 30, color: Colors.white),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Group Tasks Section
              const Text(
                "Upcoming Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 110,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (groupTasks.isEmpty)
                        _emptyTaskCard("No upcoming tasks")
                      else
                        ...groupTasks.map((task) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _taskCard(
                              title: task.title,
                              subtitle: _formatTaskTime(task.time),
                              avatars: [
                                "assets/avatar1.jpg",
                                "assets/avatar2.jpg",
                              ],
                              isNamaz: task.isNamaz,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Incomplete Tasks
              const Text(
                "Incomplete Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              if (upcomingTasks.isEmpty)
                _emptyIncompleteTask("No incomplete tasks")
              else
                Column(
                  children: upcomingTasks.map((task) {
                    return Column(
                      children: [
                        _incompleteTask(
                          task.title,
                          _formatTaskTime(task.time),
                          isNamaz: task.isNamaz,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),

              const SizedBox(height: 24),

              // Completed Tasks
              const Text(
                "Completed Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              if (completedTasks.isEmpty)
                _emptyCompletedTask("No completed tasks")
              else
                Column(
                  children: completedTasks.map((task) {
                    return Column(
                      children: [
                        _completedTask(
                          task.title,
                          _formatTaskTime(task.time),
                          isNamaz: task.isNamaz,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyTaskCard(String message) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _taskCard({
    required String title,
    required String subtitle,
    required List<String> avatars,
    bool isNamaz = false,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isNamaz)
                const Icon(Icons.mosque, size: 16, color: Colors.teal),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...avatars.map((avatar) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage(avatar),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.add, size: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyIncompleteTask(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
    );
  }

  Widget _incompleteTask(String title, String subtitle, {bool isNamaz = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          if (isNamaz)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.mosque, color: Colors.teal),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
        ],
      ),
    );
  }

  Widget _emptyCompletedTask(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
    );
  }

  Widget _completedTask(String title, String subtitle, {bool isNamaz = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          if (isNamaz)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.mosque, color: Colors.teal),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
//
// import '../tasks/domain/namaz_service.dart';
// import '../tasks/model/task_model.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String userName = "Welcome";
//   String userEmail = "";
//   String? userAddress;
//
//   List<TaskModel> groupTasks = [];
//   List<TaskModel> incompleteTasks = [];
//   List<TaskModel> completedTasks = [];
//
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAllData();
//   }
//
//   Future<void> _loadAllData() async {
//     try {
//       setState(() => loading = true);
//
//       // 1. Get Firebase user info
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         userEmail = user.email ?? '';
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();
//         if (doc.exists) {
//           userName = doc.data()?['name'] ?? userName;
//           userAddress = doc.data()?['address'];
//         }
//       }
//
//       // 2. Fetch Namaz timings & save to Hive
//       if (userAddress != null && userAddress!.isNotEmpty) {
//         await NamazService.fetchTimingsByAddress(
//           date: DateTime.now(),
//           address: userAddress!,
//           saveToBoxes: true,
//         );
//       }
//
//       // 3. Load tasks from Hive
//       final box = Hive.box<TaskModel>('tasks');
//       final now = DateTime.now();
//       final allTasks = box.values.toList();
//
//       // Group tasks (upcoming Namaz + upcoming normal tasks)
//       groupTasks = allTasks
//           .where((t) => t.time.isAfter(now))
//           .toList()
//         ..sort((a, b) => a.time.compareTo(b.time));
//
//       // Incomplete tasks (missed Namaz + normal tasks)
//       incompleteTasks = allTasks
//           .where((t) =>
//       !t.isCompleted &&
//           (!t.isNamaz || (t.isNamaz && t.time.isBefore(now))))
//           .toList();
//
//       // Completed tasks
//       completedTasks =
//           allTasks.where((t) => t.isCompleted && !t.isNamaz).toList();
//     } catch (e) {
//       debugPrint("Error loading data: $e");
//     }
//
//     setState(() => loading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D47A1),
//       body: SafeArea(
//         child: loading
//             ? const Center(
//           child: CircularProgressIndicator(color: Colors.white),
//         )
//             : SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top Profile Section
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 26,
//                     backgroundImage: AssetImage("assets/profile.jpg"),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         userName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Text(
//                         userEmail,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Stack(
//                     children: [
//                       const Icon(Icons.notifications_none,
//                           size: 30, color: Colors.white),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Text(
//                             "2",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // Group Tasks Section
//               const Text(
//                 "Group tasks",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               SizedBox(
//                 height: 110,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: groupTasks.isEmpty
//                         ? [
//                       const Text(
//                         "No upcoming tasks",
//                         style: TextStyle(color: Colors.white70),
//                       )
//                     ]
//                         : groupTasks.map((task) {
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: _taskCard(
//                           title: task.title,
//                           subtitle: DateFormat('EEE | hh:mm a')
//                               .format(task.time),
//                           avatars: [
//                             "assets/avatar1.jpg",
//                             "assets/avatar2.jpg"
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Incomplete Tasks
//               const Text(
//                 "Incomplete Tasks",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ...incompleteTasks.map((task) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: _incompleteTask(
//                   task.title,
//                   DateFormat('EEE | hh:mm a').format(task.time),
//                 ),
//               )),
//
//               const SizedBox(height: 24),
//
//               // Completed Tasks
//               const Text(
//                 "Completed Tasks",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ...completedTasks.map((task) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: _completedTask(
//                   task.title,
//                   DateFormat('EEE | hh:mm a').format(task.time),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _taskCard({
//     required String title,
//     required String subtitle,
//     required List<String> avatars,
//   }) {
//     return Container(
//       width: 160,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14)),
//           const SizedBox(height: 4),
//           Text(subtitle,
//               style: const TextStyle(color: Colors.black54, fontSize: 12)),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               ...avatars.map((avatar) => Padding(
//                 padding: const EdgeInsets.only(right: 6),
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundImage: AssetImage(avatar),
//                 ),
//               )),
//               Padding(
//                 padding: const EdgeInsets.only(right: 6),
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundColor: Colors.grey[300],
//                   child: const Icon(Icons.add, size: 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _incompleteTask(String title, String subtitle) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style: const TextStyle(color: Colors.black, fontSize: 14)),
//               const SizedBox(height: 4),
//               Text(subtitle,
//                   style: const TextStyle(color: Colors.black54, fontSize: 12)),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
//         ],
//       ),
//     );
//   }
//
//   Widget _completedTask(String title, String subtitle) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.check_circle, color: Colors.green, size: 22),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style: const TextStyle(color: Colors.black, fontSize: 14)),
//               const SizedBox(height: 4),
//               Text(subtitle,
//                   style: const TextStyle(color: Colors.black54, fontSize: 12)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
