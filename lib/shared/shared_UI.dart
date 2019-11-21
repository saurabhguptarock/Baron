import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Future<void> showToast(String text) async {
  const platform = MethodChannel('com.saverl.baron/awake');
  try {
    final ans = await platform.invokeMethod('showToast', {"text": text});
    print('Succesfully shown a Toast ' + ans);
  } on PlatformException catch (e) {
    print('Some Error Occured' + e.message);
  }
}

Future<void> playCallSound() async {
  const platform = MethodChannel('com.saverl.baron/awake');
  try {
    final ans = await platform.invokeMethod('playCallSound');
    print('Succesfully shown a Toast ' + ans);
  } on PlatformException catch (e) {
    print('Some Error Occured' + e.message);
  }
}

Future<void> endCallSound() async {
  const platform = MethodChannel('com.saverl.baron/awake');
  try {
    final ans = await platform.invokeMethod('endCallSound');
    print('Succesfully shown a Toast ' + ans);
  } on PlatformException catch (e) {
    print('Some Error Occured' + e.message);
  }
}
