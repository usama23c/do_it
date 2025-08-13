// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// class CalendarPage extends StatefulWidget {
//   const CalendarPage({Key? key}) : super(key: key);
//
//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   final Map<DateTime, List<String>> _tasks = {
//     DateTime.utc(2025, 8, 8): ["Meeting with client", "Submit report"],
//     DateTime.utc(2025, 8, 9): ["Code review"],
//   };
//
//   final Map<DateTime, List<bool>> _namazStatus = {
//     DateTime.utc(2025, 8, 8): [true, false, true, false, true],
//     DateTime.utc(2025, 8, 9): [true, true, true, true, true],
//   };
//
//
//   List<String> _getTasksForDay(DateTime day) {
//     return _tasks[DateTime.utc(day.year, day.month, day.day)] ?? [];
//   }
//
//   List<bool> _getNamazStatusForDay(DateTime day) {
//     return _namazStatus[DateTime.utc(day.year, day.month, day.day)] ??
//         [false, false, false, false, false];
//   }
//
//   void _showDayDetails(DateTime date) {
//     List<String> tasks = _getTasksForDay(date);
//     List<bool> namazStatus = _getNamazStatusForDay(date);
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade900, Colors.blue.shade700],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 DateFormat('EEEE, dd MMM yyyy').format(date),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (tasks.isNotEmpty)
//               ...tasks.map((task) => Card(
//                 color: Colors.blue.shade800.withOpacity(0.8),
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 child: ListTile(
//                   leading: const Icon(Icons.task_alt, color: Colors.white),
//                   title: Text(task, style: const TextStyle(color: Colors.white)),
//                 ),
//               )),
//             if (tasks.isEmpty)
//               const Center(
//                 child: Text("No tasks for today", style: TextStyle(color: Colors.white70)),
//               ),
//             const Divider(color: Colors.white54, thickness: 1),
//             const Text("Namaz Status", style: TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 12),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (i) {
//                   bool offered = namazStatus[i];
//                   return Container(
//                     margin: const EdgeInsets.all(6),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: offered ? Colors.green : Colors.red,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))
//                       ],
//                     ),
//                     child: Text(
//                       (i + 1).toString(),
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showTaskInput(DateTime date) {
//     String task = '';
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Set task for ${DateFormat('dd MMMM yyyy').format(date)}',
//               style: TextStyle(fontSize: 18, color: Colors.blue.shade900),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.grey.shade200,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 hintText: 'Enter task',
//               ),
//               onChanged: (value) => task = value,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
//               onPressed: () {
//                 if (task.isNotEmpty) {
//                   setState(() {
//                     final taskDate = DateTime.utc(date.year, date.month);
//                     _tasks.putIfAbsent(taskDate, () => []).add(task);
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Submit', style: TextStyle(color: Colors.white)),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Your Time", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blue[900],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {},
//         ),
//         elevation: 6,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade50, Colors.blue.shade200],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade800, Colors.blue.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: TableCalendar(
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.utc(2030, 12, 31),
//                     focusedDay: _focusedDay,
//                     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                     onDaySelected: (selectedDay, focusedDay) {
//                       setState(() {
//                         _selectedDay = selectedDay;
//                         _focusedDay = focusedDay;
//                       });
//                       _showDayDetails(selectedDay);
//                     },
//                     onPageChanged: (focusedDay) => _focusedDay = focusedDay,
//                     calendarFormat: CalendarFormat.month,
//                     headerStyle: HeaderStyle(
//                       formatButtonVisible: false,
//                       titleCentered: true,
//                       titleTextStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                       leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
//                       rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
//                     ),
//                     calendarStyle: CalendarStyle(
//                       todayDecoration: BoxDecoration(
//                         color: Colors.orange.shade400,
//                         shape: BoxShape.circle,
//                       ),
//                       selectedDecoration: BoxDecoration(
//                         color: Colors.blue.shade400,
//                         shape: BoxShape.circle,
//                       ),
//                       defaultTextStyle: const TextStyle(color: Colors.white),
//                       weekendTextStyle: const TextStyle(color: Colors.white70),
//                       outsideDaysVisible: false,
//                     ),
//                     calendarBuilders: CalendarBuilders(
//                       markerBuilder: (context, date, events) {
//                         List<Widget> markers = [];
//                         List<bool> namazStatus = _getNamazStatusForDay(date);
//                         for (int i = 0; i < 5; i++) {
//                           markers.add(Container(
//                             width: 6,
//                             height: 6,
//                             margin: const EdgeInsets.symmetric(horizontal: 1),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: namazStatus[i] ? Colors.green : Colors.red,
//                             ),
//                           ));
//                         }
//                         if (_getTasksForDay(date).isNotEmpty) {
//                           markers.add(const Icon(Icons.task_alt, size: 12, color: Colors.white));
//                         }
//                         return Row(mainAxisAlignment: MainAxisAlignment.center, children: markers);
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: _selectedDay != null
//           ? FloatingActionButton(
//         onPressed: () => _showTaskInput(_selectedDay!),
//         backgroundColor: Colors.blue.shade700,
//         child: const Icon(Icons.add, color: Colors.white),
//       )
//           : null,
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _tasks = {
    DateTime.utc(2025, 8, 8): ["Meeting with client", "Submit report"],
    DateTime.utc(2025, 8, 9): ["Code review"],
  };

  final Map<DateTime, List<bool>> _namazStatus = {
    DateTime.utc(2025, 8, 8): [true, false, true, false, true],
    DateTime.utc(2025, 8, 9): [true, true, true, true, true],
  };

  List<String> _getTasksForDay(DateTime day) {
    return _tasks[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  List<bool> _getNamazStatusForDay(DateTime day) {
    return _namazStatus[DateTime.utc(day.year, day.month, day.day)] ??
        [false, false, false, false, false];
  }

  void _showDayDetails(DateTime date) {
    List<String> tasks = _getTasksForDay(date);
    List<bool> namazStatus = _getNamazStatusForDay(date);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                DateFormat('EEEE, dd MMM yyyy').format(date),
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (tasks.isNotEmpty)
              ...tasks.map((task) => Card(
                color: AppColors.primary.withOpacity(0.8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.task_alt, color: AppColors.textWhite),
                  title: Text(task, style: TextStyle(color: AppColors.textWhite)),
                ),
              )),
            if (tasks.isEmpty)
              Center(
                child: Text("No tasks for today",
                    style: TextStyle(color: AppColors.textWhite70)),
              ),
            Divider(color: AppColors.textWhite.withOpacity(0.5), thickness: 1),
            Text("Namaz Status",
                style: TextStyle(color: AppColors.textWhite, fontSize: 18)),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  bool offered = namazStatus[i];
                  return Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: offered ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 6,
                            offset: const Offset(0, 3)
                        )
                      ],
                    ),
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(color: AppColors.textWhite, fontSize: 14),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showTaskInput(DateTime date) {
    String task = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set task for ${DateFormat('dd MMMM yyyy').format(date)}',
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryDark
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter task',
              ),
              onChanged: (value) => task = value,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () {
                if (task.isNotEmpty) {
                  setState(() {
                    final taskDate = DateTime.utc(date.year, date.month);
                    _tasks.putIfAbsent(taskDate, () => []).add(task);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Submit',
                  style: TextStyle(color: AppColors.textWhite)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Your Time",
            style: TextStyle(color: AppColors.textWhite)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textWhite),
          onPressed: () {},
        ),
        elevation: 6,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundLight, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _showDayDetails(selectedDay);
                    },
                    onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                    calendarFormat: CalendarFormat.month,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textWhite,
                      ),
                      leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: AppColors.textWhite
                      ),
                      rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: AppColors.textWhite
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: AppColors.textWhite),
                      weekendTextStyle: TextStyle(color: AppColors.textWhite70),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        List<Widget> markers = [];
                        List<bool> namazStatus = _getNamazStatusForDay(date);
                        for (int i = 0; i < 5; i++) {
                          markers.add(Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: namazStatus[i]
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ));
                        }
                        if (_getTasksForDay(date).isNotEmpty) {
                          markers.add(Icon(
                              Icons.task_alt,
                              size: 12,
                              color: AppColors.textWhite
                          ));
                        }
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: markers
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedDay != null
          ? FloatingActionButton(
        onPressed: () => _showTaskInput(_selectedDay!),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.textWhite),
      )
          : null,
    );
  }
}
