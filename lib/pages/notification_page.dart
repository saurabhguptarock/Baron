import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(23, 31, 42, 1),
        actions: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                FontAwesomeIcons.redoAlt,
                size: 17,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Icon(
                FontAwesomeIcons.ellipsisV,
                size: 17,
                color: Colors.white,
              ),
            ),
          ),
        ],
        title: Text(
          'Notifications',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
