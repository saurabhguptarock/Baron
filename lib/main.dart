import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/collectibles_page.dart';
import 'package:Baron/pages/home_page.dart';
import 'package:Baron/pages/notification_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:Baron/users/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
        theme: ThemeData(primaryColor: Colors.white),
        home: QuickActionsManager(),
        routes: <String, WidgetBuilder>{
          "/login": (BuildContext context) => LoginPage(),
          "/collectibles": (BuildContext context) => CollectiblesPage(),
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

List<ProductDetails> appProducts = [];

class _QuickActionsManagerState extends State<QuickActionsManager> {
  FirebaseUser users;
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      Set<String> ids = Set.from([
        '1_soura',
        '2_soura',
        '3_soura',
        '4_soura',
        '5_soura',
      ]);
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      setState(() {
        appProducts = response.productDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return checkIfLoggedIn(user);
  }

  Widget loadDynamicLinkPage(String path) {
    if (path == '/soura')
      return SouraPage();
    else if (path == '/notifications')
      return NotificationsPage();
    else if (path == '/settings')
      return SettingsPage();
    else if (path == '/collectibles')
      return CollectiblesPage();
    else
      return HomePage();
  }

  void initDynamicLinks(FirebaseUser user) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      var path = deepLink.path;
      Widget pathWidget = loadDynamicLinkPage(path);
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return StreamProvider<User>.value(
          initialData: User.fromMap({}),
          value: firebaseService.streamUser(user.uid),
          child: pathWidget,
        );
      }));
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        var path = deepLink.path;
        Widget pathWidget = loadDynamicLinkPage(path);
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return StreamProvider<User>.value(
            initialData: User.fromMap({}),
            value: firebaseService.streamUser(user.uid),
            child: pathWidget,
          );
        }));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Widget checkIfLoggedIn(FirebaseUser user) {
    if (user != null) {
      initDynamicLinks(user);
      return StreamProvider<User>.value(
        initialData: User.fromMap({}),
        value: firebaseService.streamUser(user.uid),
        child: StreamProvider<List<PhoneDetails>>.value(
            value: firebaseService.streamPhoneDetails(user.uid),
            child: HomePage()),
      );
    } else
      return LoginPage();
  }
}
