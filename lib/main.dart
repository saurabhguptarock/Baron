import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/collectibles_page.dart';
import 'package:Baron/pages/home_page.dart';
import 'package:Baron/pages/inventory_page.dart';
import 'package:Baron/pages/leaderboard_page.dart';
import 'package:Baron/pages/notification_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/pages/upgrade_page.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/users/login.dart';
import 'package:Baron/users/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<List<Collectible>>.value(
          value: firebaseService.streamCollectible(),
        ),
      ],
      child: MaterialApp(
        title: 'Baron',
        theme: ThemeData(primaryColor: Color.fromRGBO(231, 38, 61, 1)),
        home: QuickActionsManager(),
        routes: <String, WidgetBuilder>{
          "/profile": (BuildContext context) => ProfilePage(),
          "/login": (BuildContext context) => LoginPage(),
          "/upgrade": (BuildContext context) => UpgradePage(),
          "/leaderboard": (BuildContext context) => LeaderBoard(),
          "/collectibles": (BuildContext context) => CollectiblesPage(),
          "/inventory": (BuildContext context) => InventoryPage(),
          "/settings": (BuildContext context) => SettingsPage(),
          "/notifications": (BuildContext context) => NotificationsPage(),
          "/soura": (BuildContext context) => SouraPage(),
          "/home": (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}

class QuickActionsManager extends StatefulWidget {
  @override
  _QuickActionsManagerState createState() => _QuickActionsManagerState();
}

class _QuickActionsManagerState extends State<QuickActionsManager> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return checkIfLoggedIn(user);
  }

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Widget checkIfLoggedIn(FirebaseUser user) {
    if (user != null)
      return StreamProvider<User>.value(
        initialData: User.fromMap({}),
        value: firebaseService.streamUser(user.uid),
        child: HomePage(),
      );
    else
      return LoginPage();
  }
}
