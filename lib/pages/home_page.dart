import 'dart:io';
import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/collectibles_page.dart';
import 'package:Baron/pages/inventory_page.dart';
import 'package:Baron/pages/leaderboard_page.dart';
import 'package:Baron/pages/notification_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/pages/upgrade_page.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/shared/shared_UI.dart';
import 'package:Baron/users/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
    _messaging.configure(onMessage: (Map<String, dynamic> message) async {
      final snackbar = SnackBar(
        content: Text(message['notification']['title']),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => Navigator.of(context).pushNamed('/collectibles'),
        ),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }, onLaunch: (Map<String, dynamic> message) async {
      Navigator.of(context).pushNamed('/collectibles');
    }, onResume: (Map<String, dynamic> message) async {
      Navigator.of(context).pushNamed('/collectibles');
    });
    _messaging.subscribeToTopic('collectibles');
  }

  void saveDeviceToken(String uid) async {
    String token = await _messaging.getToken();
    if (token != null) {
      var tokenRef = _firestore
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(token);
      await tokenRef.setData({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final userDetails = Provider.of<User>(context);
    saveDeviceToken(user.uid);
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
                          CachedNetworkImage(
                            imageUrl: user.photoUrl,
                            imageBuilder: (ctx, imageProvider) => CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 35,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/${userDetails.badge}.webp'),
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
                                        'assets/images/${userDetails.tyre}.webp'),
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: ProfilePage(),
                      );
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: LeaderBoard(),
                      );
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: InventoryPage(),
                      );
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: SouraPage(),
                      );
                    }));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.coins,
                          color: Colors.grey,
                          size: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                        ),
                        Text(
                          'Soura',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: UpgradePage(),
                      );
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: CollectiblesPage(),
                      );
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                          initialData: User.fromMap({}),
                          value: firebaseService.streamUser(user.uid),
                          child: NotificationsPage());
                    }));
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return StreamProvider<User>.value(
                        initialData: User.fromMap({}),
                        value: firebaseService.streamUser(user.uid),
                        child: SettingsPage(),
                      );
                    }));
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
                  onTap: () async {
                    final DynamicLinkParameters parameters =
                        DynamicLinkParameters(
                      uriPrefix: 'https://baron.page.link',
                      link: Uri.parse('https://saverl.com/soura'),
                      androidParameters: AndroidParameters(
                          packageName: 'com.saverl.baron',
                          fallbackUrl: Uri.parse('https://baron.saverl.com/')),
                      iosParameters: IosParameters(
                          bundleId: 'com.saverl.baron',
                          fallbackUrl: Uri.parse('https://baron.saverl.com/')),
                      socialMetaTagParameters: SocialMetaTagParameters(
                        title: 'Baron',
                        description: 'Download Baron a competitive game app',
                      ),
                    );
                    final ShortDynamicLink dynamicUrl =
                        await parameters.buildShortLink();
                    final Uri shortUrl = dynamicUrl.shortUrl;
                    Share.share(
                        'Download Baron a competitive game app. $shortUrl');
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
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return StreamProvider<User>.value(
                          initialData: User.fromMap({}),
                          value: firebaseService.streamUser(user.uid),
                          child: NotificationsPage(),
                        );
                      }));
                    },
                    icon: Stack(
                      children: <Widget>[
                        Positioned(
                          top: userDetails.noOfNotification != 0 ? 10 : 5,
                          right: 3,
                          child: Icon(
                            FontAwesomeIcons.bell,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        if (userDetails.noOfNotification != 0)
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
