import 'package:flutter/material.dart';
import '../menu_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/villafest_logo.jpeg'),
      ),
      title: Text('Villafest', style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
      ],
    );
  }
} 