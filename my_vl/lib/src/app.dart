import 'package:flutter/material.dart';
import 'screens/hello_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/restauration_screen.dart';
import 'screens/settings_screen.dart';
import 'blocs/auth_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyVL',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return HelloScreen();
          },
          '/auth': (BuildContext context) {
            // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
            return AuthScreen();
            //AuthProvider(
            //  child: SignUpScreen(),
            //);
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
      ),
    );
  }
}
