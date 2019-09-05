import 'package:Baron/model/user_model.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/shared/shared_UI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final userDetails = Provider.of<User>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Color.fromRGBO(52, 61, 88, 1),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 100,
                left: 10,
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.displayName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          FontAwesomeIcons.folder,
                          color: Colors.white,
                          size: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        ),
                        Text(
                          'Upgrade',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: InkWell(
                  onTap: () => firebaseService.signOut(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(143, 144, 155, 1),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    height: 50,
                    child: Center(
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 85),
                    child: Container(
                      color: Colors.yellow,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text('asdasd'),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text('asdasd'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 85,
            color: Color.fromRGBO(23, 31, 42, 1),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: MediaQuery.of(context).padding.top),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(27, 35, 47, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Search for user or team...',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                color: Colors.white30),
                          ),
                          Icon(
                            FontAwesomeIcons.search,
                            color: Color.fromRGBO(253, 125, 73, 1),
                            size: 13,
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/notifications'),
                    icon: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10,
                          right: 3,
                          child: Icon(
                            FontAwesomeIcons.bell,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 3,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(222, 97, 59, 1),
                                  Color.fromRGBO(231, 39, 61, 1)
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${userDetails.noOfNotification}',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
