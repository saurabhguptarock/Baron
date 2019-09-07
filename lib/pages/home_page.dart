import 'package:Baron/model/user_model.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/shared/shared_UI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                  color: Color.fromRGBO(52, 61, 88, 1),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                            radius: 35,
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/${userDetails.badge}.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 7),
                              ),
                              Text(
                                userDetails.badge,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.displayName,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${userDetails.followers} Followers',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: AssetImage(
                                        'assets/images/${userDetails.tyre}.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 7),
                                  ),
                                  Text(
                                    userDetails.tyre,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/profile');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.user,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/leaderboard');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.chartBar,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Leaderboard',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/inventory');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.box,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Inventory',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/upgrade');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.angleDoubleUp,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Upgrade',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/collectibles');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.archive,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Collectibles',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/notifications');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        userDetails.noOfNotification > 0
                            ? Stack(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.grey,
                                    size: 23,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 3,
                                    ),
                                  )
                                ],
                              )
                            : Icon(
                                FontAwesomeIcons.bell,
                                color: Colors.grey,
                                size: 23,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Notifications',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/settings');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.userCog,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => firebaseService.signOut(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 80),
                ),
                Divider(
                  height: 0,
                  color: Colors.grey,
                  indent: 15,
                  endIndent: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                InkWell(
                  onTap: () {
                    Share.share(
                        'Download Baron a competitive game app. https://bit.ly/2lBMjfk');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.shareAlt,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Tell a Friend',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.questionCircle,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Help and Feedback',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
