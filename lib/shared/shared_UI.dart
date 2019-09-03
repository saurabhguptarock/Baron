import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Widget premiumAvatarCard(String name) {
  return InkWell(
    onTap: () => print(name),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 32,
            backgroundImage: AssetImage('assets/images/$name.png'),
          ),
        ),
        Text(
          name,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
      ],
    ),
  );
}
