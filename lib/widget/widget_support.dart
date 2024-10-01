import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headerlineStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 25,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle lightTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle descriptionTextStyle() {
    return const TextStyle(
        fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey);
  }

  static TextStyle titleTextStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
  }

  static TextStyle titleDetailTextStyle() {
    return const TextStyle(fontSize: 23, fontWeight: FontWeight.w800);
  }
}
