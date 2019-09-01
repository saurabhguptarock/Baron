import 'package:flutter/material.dart';

class UpgradePage extends StatefulWidget {
  @override
  _UpgradePageState createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Upgrade',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
