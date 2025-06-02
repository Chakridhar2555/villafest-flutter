import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'host_and_earn_page.dart';

void main() {
  runApp(VillaFestApp());
}

class VillaFestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Villafest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Color(0xFFF7FAFC),
      ),
      home: SplashPage(),
      routes: {
        '/home': (_) => HomePage(),
        '/search': (_) => SearchPage(),
        '/host': (_) => HostAndEarnPage(),
      },
    );
  }
}
