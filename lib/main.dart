import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green,
      drawer: Drawer(
        child: Text('data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: InkWell(
          onTap: () => _scaffoldKey.currentState.openDrawer(),
          child: SizedBox(
            height: 20,
            width: 20,
            child: SpinKitRing(
              color: Colors.red,
              duration: Duration(milliseconds: 800),
              size: 30,
              lineWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
