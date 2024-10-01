import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/auth_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50), // Space from the top of the screen
                CircleAvatar(
                  radius: 80, // Larger profile image
                  backgroundImage: NetworkImage(
                      'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D'), // Replace with actual image URL or asset
                ),
                SizedBox(height: 20),
                Text(
                  "Grace",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold), // Increased font size
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 10,
          child: IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              await _authController.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      ],
    );
  }
}
