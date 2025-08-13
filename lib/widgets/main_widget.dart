import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../views/calendar/calendar_page.dart';
import '../views/home/home_page.dart';
import '../views/settings/profile_page.dart';
import '../views/tasks/task_list_page.dart';
import '../widgets/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  final List<GlobalKey<NavigatorState>> _navigatorKeys =
  List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
              break;
            case 1:
              page = const TasksListScreen();
              break;
            case 2:
              page = const CalendarPage();
              break;
            case 3:
            default:
              page = const ProfileScreen();
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }

  void _selectTab(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: List.generate(4, (i) => _buildOffstageNavigator(i))),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
    );
  }
}