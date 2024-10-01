import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed 'const' here
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: const Column(
          children: [
            Text("Wallet"),
          ],
        ),
      ),
    );
  }
}
