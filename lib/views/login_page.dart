import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/views/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getBool('role');
    if (token != null) {
      // User is already logged in, navigate to BottomNavigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNavigation(role: role ?? false)),
      );
    }
  }

  Future<void> _handleEmailPasswordSignIn() async {
    final user = await _authController.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
    assert(user != null, 'User is null');
    _handleNavigationHome(user);
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await _authController.signInWithGoogle();
    _handleNavigationHome(user);
  }

  Future<void> _handleNavigationHome(user) async {
    final role = await _authController.getRole(user.id);
    if (user != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigation(role: role)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GRACE LOGIN',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 225, 163, 232)),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter email address',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleEmailPasswordSignIn,
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: _handleGoogleSignIn,
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
