import 'dart:io';
import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/collectibles_page.dart';
import 'package:Baron/pages/notification_page.dart';
import 'package:Baron/pages/searchuserprofile_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/shared/shared_UI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final List<DocumentSnapshot> userList = [];

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
    final Firestore _firestore = Firestore.instance;

    _firestore
        .collection('users')
        .getDocuments()
        .then((val) => userList.addAll(val.documents));
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
    final recentActivity = Provider.of<List<RecentActivity>>(context);
    saveDeviceToken(user.uid);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: SpeedDial(
        tooltip: 'Functions',
        backgroundColor: Color.fromRGBO(16, 24, 30, 1),
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.red,
            onTap: () {},
            label: 'Start a new call',
            child: Icon(FontAwesomeIcons.phoneAlt),
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            onTap: () {},
            label: 'Start a new chat',
            child: Icon(FontAwesomeIcons.sms),
          ),
          SpeedDialChild(
            backgroundColor: Colors.yellow,
            onTap: () {},
            label: 'Start a new video call',
            child: Icon(FontAwesomeIcons.video),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromRGBO(27, 36, 48, 1),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                color: Color.fromRGBO(23, 31, 42, 1),
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
                          placeholder: (context, url) => Shimmer(
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(221, 221, 221, 1),
                              Colors.white,
                              Color.fromRGBO(221, 221, 221, 1),
                            ]),
                            child: CircleAvatar(
                              radius: 25,
                            ),
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
                padding: const EdgeInsets.only(top: 210),
                child: Column(
                  children: <Widget>[
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
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.coins,
                              color: Colors.white,
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
                                  color: Colors.white),
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
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.archive,
                              color: Colors.white,
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
                                  color: Colors.white),
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
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.userCog,
                              color: Colors.white,
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
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => firebaseService.signOut(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: Colors.white,
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
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          final DynamicLinkParameters parameters =
                              DynamicLinkParameters(
                            uriPrefix: 'https://baron.page.link',
                            link: Uri.parse('https://saverl.com/soura'),
                            androidParameters: AndroidParameters(
                                packageName: 'com.saverl.baron',
                                fallbackUrl:
                                    Uri.parse('https://baron.saverl.com/')),
                            iosParameters: IosParameters(
                                bundleId: 'com.saverl.baron',
                                fallbackUrl:
                                    Uri.parse('https://baron.saverl.com/')),
                            socialMetaTagParameters: SocialMetaTagParameters(
                              title: 'Baron',
                              description:
                                  'Download Baron a competitive game app',
                            ),
                          );
                          final ShortDynamicLink dynamicUrl =
                              await parameters.buildShortLink();
                          final Uri shortUrl = dynamicUrl.shortUrl;
                          Share.share(
                              'Download Baron a competitive game app. $shortUrl');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.shareAlt,
                                color: Colors.white,
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
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.solidQuestionCircle,
                                color: Colors.white,
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
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  if (recentActivity != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 85),
                    ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color.fromRGBO(27, 36, 48, 1),
                    child: recentActivity != null
                        ? recentActivity.length > 0
                            ? ListView.builder(
                                itemCount: recentActivity.length,
                                itemBuilder: (ctx, i) =>
                                    recentActivityCard(recentActivity[i]),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {},
                                  ),
                                  Text('data'),
                                ],
                              )
                        : ListView.builder(
                            itemCount: 9,
                            itemBuilder: (ctx, i) => recentActivityCard(
                                RecentActivity(
                                    img: '',
                                    name: '',
                                    time: '',
                                    wasIncoming: false)),
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
                    child: InkWell(
                      onTap: () => showSearch(
                          context: context, delegate: DataSearch(userDetails)),
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
                              'Search for your friends...',
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

Widget recentActivityCard(RecentActivity recentActivity) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: Container(
      child: ListTile(
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.sms,
            color: Colors.white,
          ),
        ),
        onLongPress: () {},
        onTap: () {},
        leading: CachedNetworkImage(
          imageUrl: recentActivity.img,
          imageBuilder: (ctx, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 25,
          ),
          placeholder: (context, url) => Shimmer(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(221, 221, 221, 1),
              Colors.white,
              Color.fromRGBO(221, 221, 221, 1),
            ]),
            child: CircleAvatar(
              radius: 25,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(
          '${recentActivity.name}',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(
                recentActivity.wasIncoming == false
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
                color: Colors.green,
                size: 18,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
            ),
            Text(
              '${recentActivity.time}',
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      IconSlideAction(
        color: Colors.green,
        foregroundColor: Colors.white,
        icon: FontAwesomeIcons.phoneAlt,
        onTap: () {},
      ),
    ],
    secondaryActions: <Widget>[
      IconSlideAction(
        color: Colors.green,
        foregroundColor: Colors.white,
        icon: FontAwesomeIcons.video,
        onTap: () {},
      ),
    ],
  );
}

class DataSearch extends SearchDelegate<String> {
  final User currentUser;

  DataSearch(this.currentUser);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<DocumentSnapshot> users = query.isEmpty
        ? userList
        : userList
            .where((p) =>
                p.data['name'].toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, idx) => ListTile(
        onTap: () {
          close(context, null);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return StreamProvider<User>.value(
                  initialData: User.fromMap({}),
                  value:
                      firebaseService.streamUser("${users[idx].data['uid']}"),
                  child: SearchUserProfile(
                    currentUser: currentUser,
                  ),
                );
              },
            ),
          );
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage("${users[idx].data['photoUrl']}"),
        ),
        title: RichText(
          text: TextSpan(
            text: '${users[idx].data['name']}'.substring(0, query.length),
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18),
            children: [
              TextSpan(
                text: '${users[idx].data['name']}'.substring(query.length),
                style: TextStyle(
                    fontFamily: 'OpenSans', fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
