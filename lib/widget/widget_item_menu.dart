import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
GestureDetector ItemMenu(name, isSelected, selectedFood, setState) {
  return GestureDetector(
    onTap: () => {
      selectedFood(name),
      setState(() {}),
    },
    child: Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 218, 243, 255)
                : Colors.white,
            borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(
          "images/$name.png",
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
