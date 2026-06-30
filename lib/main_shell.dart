import 'package:flutter/material.dart';
import 'home.dart';
import 'history.dart';
import 'profile.dart';
import 'message.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const Color inkBlue = Color(0xFF003366);

  int currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ServiceHistoryScreen(),
    ProfilePage(),
    MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: inkBlue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
        ],
      ),
    );
  }
}