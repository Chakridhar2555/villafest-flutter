import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'host_and_earn_page.dart';
import 'login_page.dart';
import 'signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await dotenv.load(fileName: ".env").catchError((error) {
    print('Error loading .env file: $error');
    // Create default environment variables if .env file is not found
    dotenv.env.addAll({'SERVER_URL': 'http://localhost:3000'});
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignupPage(),
      },
    );
  }
}
