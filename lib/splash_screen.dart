import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart' show isLoggedIn;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => isLoggedIn == true
            ? Navigator.of(context).pushReplacementNamed('/home')
            : Navigator.of(context).pushReplacementNamed('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Center(
            child: Image(
              image: AssetImage("assets/logos/icon.png"),
            ),
          )
        ],
      ),
    );
  }
}
