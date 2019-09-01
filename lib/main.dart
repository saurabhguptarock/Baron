import 'package:Baron/pages/settings_page.dart';
import 'package:Baron/pages/upgrade_page.dart';
import 'package:Baron/splash_screen.dart';
import 'package:Baron/users/login.dart';
import 'package:Baron/users/profile.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

bool isLoggedIn;
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
    return MaterialApp(
      title: 'QuickActions Demo',
      theme: isDark == true ? ThemeData.dark() : ThemeData.light(),
      home: QuickActionsManager(),
      routes: <String, WidgetBuilder>{
        "/profile": (BuildContext context) => ProfilePage(),
        "/login": (BuildContext context) => LoginPage(),
        "/upgrade": (BuildContext context) => UpgradePage(),
        "/settings": (BuildContext context) => SettingsPage(),
      },
    );
  }
}

class QuickActionsManager extends StatefulWidget {
  @override
  _QuickActionsManagerState createState() => _QuickActionsManagerState();
}

class _QuickActionsManagerState extends State<QuickActionsManager> {
  final QuickActions quickActions = QuickActions();
  void _setupQuickActions() {
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
          type: 'action_profile', localizedTitle: 'Profile', icon: 'user'),
      ShortcutItem(
          type: 'action_upgrade', localizedTitle: 'Upgrade', icon: 'upgrade'),
      ShortcutItem(
          type: 'action_settings',
          localizedTitle: 'Settings',
          icon: 'settings'),
    ]);
  }

  void _handleQuickActions() {
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_profile') {
        Navigator.pushNamed(context, '/profile');
      } else if (shortcutType == 'action_upgrade') {
        Navigator.pushNamed(context, '/upgrade');
      } else if (shortcutType == 'action_settings') {
        Navigator.pushNamed(context, '/settings');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }

  @override
  void initState() {
    super.initState();
    checkTheme();
    checkLogin();
    _setupQuickActions();
    _handleQuickActions();
  }
}
