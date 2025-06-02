import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == selectedIndex) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/host');
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Host & Earn',
          ),
        ],
      ),
    );
  }
} 