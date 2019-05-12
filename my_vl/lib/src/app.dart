import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'pages/root_page.dart';
import 'pages/hello_page.dart';
import 'pages/activity_page.dart';
import 'pages/activity_screens/restauration_screen.dart';
import 'pages/activity_screens/settings_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyVL',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return RootPage(auth: Auth());
        },
        '/activity': (BuildContext context) {
          return ActivityPage();
        },
        '/restauration': (BuildContext context) {
          return RestaurationScreen();
        },
        '/settings': (BuildContext context) {
          return SettingsScreen();
        },
      },
    );
  }
}
