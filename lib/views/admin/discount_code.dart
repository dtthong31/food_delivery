import 'package:flutter/material.dart';
import 'package:food_delivery/widget/widget_theme_bar.dart';

class DiscountCodeScreen extends StatefulWidget {
  const DiscountCodeScreen({super.key});

  @override
  State<DiscountCodeScreen> createState() => _DiscountCodeScreenState();
}

class _DiscountCodeScreenState extends State<DiscountCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return const ThemeWidget(child: Text(" Discount code"));
  }
}
