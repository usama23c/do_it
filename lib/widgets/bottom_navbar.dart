import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  BottomNavigationBarItem _navBarItem(IconData icon, int index) {
    bool isActive = currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(2), // 🔹 reduced from 8 to 4
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
            colors: [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isActive ? null : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: isActive ? 26 : 22, // 🔹 slightly smaller icons
          color: isActive ? Colors.white : Colors.white70,
        ),
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          _navBarItem(LucideIcons.home, 0),       // Home
          _navBarItem(LucideIcons.listTodo, 1),   // Tasks
          _navBarItem(LucideIcons.calendar, 2),  // Calendar
          _navBarItem(LucideIcons.user, 3),      // Profile
        ],
      ),
    );
  }
}
