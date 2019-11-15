import 'package:flutter/material.dart';

class PhoneCallPage extends StatefulWidget {
  final Map<String, dynamic> userOnPhone;

  const PhoneCallPage({Key key, this.userOnPhone}) : super(key: key);
  @override
  _PhoneCallPageState createState() => _PhoneCallPageState();
}

class _PhoneCallPageState extends State<PhoneCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userOnPhone['name']}+1+1'),
      ),
    );
  }
}
