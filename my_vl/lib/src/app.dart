import 'package:flutter/material.dart';
import 'screens/hello_screen.dart';
import 'screens/signup_screen.dart';
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
          '/signup': (BuildContext context) {
            // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
            return SignUpScreen();
          },
        },
      ),
    );
  }
}
