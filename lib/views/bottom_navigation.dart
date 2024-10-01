import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/views/admin/discount_code.dart';
import 'package:food_delivery/views/admin/food_management.dart';
import 'package:food_delivery/views/admin/order_admin.dart';
import 'package:food_delivery/views/customer/home.dart';
import 'package:food_delivery/views/customer/order.dart' as order_view;
import 'package:food_delivery/views/customer/profile.dart';
import 'package:food_delivery/views/admin/home_admin.dart';
import 'package:food_delivery/views/customer/wallet.dart';

class BottomNavigation extends StatefulWidget {
  final bool role;
  const BottomNavigation({super.key, required this.role});
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTabIndex = 0;
  late Widget order;
  late Widget home;
  late Widget profile;
  late Widget wallet;
  late List<Widget> pages = []; // Initialize pages with an empty list
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  Future<void> _initializePages() async {
    if (widget.role) {
      home = const HomeAdminScreen();
      order = OrderAdminScreen();
      wallet = FoodManagementScreen();
      profile = const DiscountCodeScreen();
      pages = [home, order, wallet, profile];
    } else {
      home = const Home();
      order = const order_view.Order();
      profile = const Profile();
      wallet = const Wallet();
      pages = [home, order, wallet, profile];
    }
  }

  @override
  Widget build(BuildContext context) {
    var role = widget.role;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65.0,
          color: Colors.black,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          animationDuration: const Duration(milliseconds: 500),
          onTap: (value) => {currentTabIndex = value, setState(() {})},
          items: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            Icon(role ? Icons.food_bank_outlined : Icons.wallet,
                color: Colors.white),
            Icon(role ? Icons.discount_outlined : Icons.person_2_outlined,
                color: Colors.white),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
