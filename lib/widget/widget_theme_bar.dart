import 'package:flutter/material.dart';

class ThemeWidget extends StatelessWidget {
  final Widget child;

  const ThemeWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 30),
      child: child,
    );
  }
}
