import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'screens/hello_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/restauration_screen.dart';
import 'screens/settings_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyVL',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return HelloScreen();
        },
        '/auth': (BuildContext context) {
          // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
          return AuthScreen(auth: Auth(),);
          // AuthProvider(
          //   child: SignUpScreen(),
          // );
        },
        '/activity': (BuildContext context) {
          return ActivityScreen();
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
