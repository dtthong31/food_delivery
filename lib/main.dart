import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery/views/bottom_navigation.dart';
import 'package:food_delivery/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final role = prefs.getBool('role');

  runApp(MyApp(
      initialRoute: token != null ? '/home' : '/login', role: role ?? false));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool role;

  const MyApp({super.key, required this.initialRoute, required this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => BottomNavigation(role: role),
      },
    );
  }
}
