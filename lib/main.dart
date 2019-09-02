import 'package:Baron/pages/home_page.dart';
import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/upgrade_page.dart';
import 'package:Baron/users/login.dart';
import 'package:Baron/users/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

bool isLoggedIn = false;
bool isDark = false;

checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
}

checkTheme() async {
  final prefs = await SharedPreferences.getInstance();
  isDark = prefs.getBool("theme") ?? false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        )
      ],
      child: MaterialApp(
        title: 'QuickActions Demo',
        theme: isDark == true ? ThemeData.dark() : ThemeData.light(),
        home: QuickActionsManager(),
        routes: <String, WidgetBuilder>{
          "/profile": (BuildContext context) => ProfilePage(),
          "/login": (BuildContext context) => LoginPage(),
          "/upgrade": (BuildContext context) => UpgradePage(),
          "/settings": (BuildContext context) => SettingsPage(),
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
    var user = Provider.of(context);
    return checkIfLoggedIn(user);
  }

  Widget checkIfLoggedIn(FirebaseUser user) {
    if (user != null)
      return HomePage();
    else
      return LoginPage();
  }
}
