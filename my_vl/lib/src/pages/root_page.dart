import 'package:flutter/material.dart';
import 'package:my_vl/src/pages/activity_page.dart';
import 'package:my_vl/src/pages/hello_page.dart';
import '../blocs/auth_provider.dart';
import '../services/authentication.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = AuthProvider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isSignedIn = snapshot.hasData;
          return isSignedIn ? ActivityPage() : HelloPage();
        }
        return _waitingScreen();
      },
    );
  }

  Widget _waitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}