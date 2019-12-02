import 'dart:io';
import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/collectibles_page.dart';
import 'package:Baron/pages/notification_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/shared/shared_UI.dart';
import 'package:Baron/video_call/pages/call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final List<DocumentSnapshot> userList = [];
User souraBuyUser;

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
    final phoneDetails = Provider.of<List<PhoneDetails>>(context);
    saveDeviceToken(user.uid);
    setState(() {
      souraBuyUser = userDetails;
    });
    return Scaffold(
      key: _scaffoldKey,
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
                          imageUrl: userDetails.photoUrl,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 35,
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: CircleAvatar(
                              radius: 35,
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
                                fallbackUrl: Uri.parse(
                                    'https://play.google.com/store/apps/details?id=com.saverl.baron')),
                            iosParameters: IosParameters(
                                bundleId: 'com.saverl.baron',
                                fallbackUrl: Uri.parse(
                                    'https://play.google.com/store/apps/details?id=com.saverl.baron')),
                            socialMetaTagParameters: SocialMetaTagParameters(
                              title: 'Baron',
                              description:
                                  'Download Baron a live chat and video call app',
                            ),
                          );
                          final ShortDynamicLink dynamicUrl =
                              await parameters.buildShortLink();
                          final Uri shortUrl = dynamicUrl.shortUrl;
                          Share.share(
                              'Download Baron a live chat and video call app. $shortUrl');
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
                  phoneDetails != null
                      ? phoneDetails.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 85),
                            )
                          : SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 85),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color.fromRGBO(27, 36, 48, 1),
                    child: phoneDetails != null
                        ? phoneDetails.length > 0
                            ? ListView.builder(
                                itemCount: phoneDetails.length,
                                itemBuilder: (ctx, i) => phoneDetailsCard(
                                    phoneDetails[i],
                                    userDetails.uid,
                                    true,
                                    userDetails,
                                    context),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Color.fromRGBO(27, 36, 48, 1),
                                        BlendMode.multiply),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/not-found.webp'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => showSearch(
                                        context: context,
                                        delegate: DataSearch(userDetails)),
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(23, 31, 42, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          'Start new Call',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Color.fromRGBO(27, 36, 48, 1),
                                  BlendMode.multiply),
                              child: Image(
                                image:
                                    AssetImage('assets/images/not-found.webp'),
                              ),
                            ),
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

Future<bool> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions([
    PermissionGroup.camera,
    PermissionGroup.microphone,
    PermissionGroup.location
  ]);
  PermissionStatus permissionStatus1 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.camera,
  );
  PermissionStatus permissionStatus2 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.microphone,
  );
  if (permissionStatus1.value == 2 && permissionStatus2.value == 2)
    return Future.value(true);
  else
    return Future.value(false);
}

Widget phoneDetailsCard(PhoneDetails phoneDetails, String uid, bool isDeletable,
    User currentUser, BuildContext context) {
  return Container(
    child: ListTile(
      onTap: () async {
        bool isGranted = await _handleCameraAndMic();
        if (isGranted) {
          if (phoneDetails.calledByUid == currentUser.uid) {
            if (phoneDetails.wasIncoming)
              firebaseService
                  .callUserBackend(currentUser, phoneDetails.channelName, {
                'photoUrl': phoneDetails.img,
                'uid': phoneDetails.channelName,
                'name': phoneDetails.name,
              });
            else
              firebaseService
                  .callUserBackend(currentUser, phoneDetails.channelName, {
                'photoUrl': phoneDetails.img,
                'uid': phoneDetails.calledToUid,
                'name': phoneDetails.name,
              });
          } else {
            firebaseService
                .callUserBackend(currentUser, phoneDetails.channelName, {
              'photoUrl': phoneDetails.img,
              'uid': phoneDetails.calledByUid,
              'name': phoneDetails.name,
            });
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: CallPage(
                  channelName: phoneDetails.channelName,
                ),
              ),
            ),
          );
        } else {
          showToast('Please Grant Permission');
        }
      },
      trailing: IconButton(
        onPressed: () => isDeletable
            ? firebaseService.deleteTile(uid, phoneDetails.docId)
            : null,
        icon: Icon(
          Icons.delete_forever,
          color: Colors.red,
          size: 30,
        ),
      ),
      leading: CachedNetworkImage(
        imageUrl: phoneDetails.img,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundColor: Color.fromRGBO(27, 36, 48, 1),
          backgroundImage: imageProvider,
          radius: 25,
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: CircleAvatar(
            radius: 25,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text(
        '${phoneDetails.name}',
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
              phoneDetails.wasIncoming == false
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
            '${phoneDetails.time}',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

class DataSearch extends SearchDelegate<String> {
  final User currentUser;

  DataSearch(this.currentUser);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: theme.primaryTextTheme.title.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: theme.primaryTextTheme.title.color)));
  }

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
    List<DocumentSnapshot> newuserList = userList;
    newuserList.removeWhere((d) => d.data['uid'] == currentUser.uid);
    final List<DocumentSnapshot> users = query.isEmpty
        ? newuserList
        : newuserList
            .where((p) =>
                p.data['name'].toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, idx) => ListTile(
        onTap: () async {
          bool isGranted = await _handleCameraAndMic();
          if (isGranted) {
            firebaseService.callUserBackend(
                currentUser, users[idx].data['uid'], users[idx].data);
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: CallPage(
                    channelName: users[idx].data['uid'],
                  ),
                ),
              ),
            );
          } else {
            showToast('Please Grant Permission');
          }
        },
        leading: CachedNetworkImage(
          imageUrl: users[idx].data['photoUrl'],
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: CircleAvatar(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
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
