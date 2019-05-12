import 'package:flutter/material.dart';
import 'package:my_vl/src/pages/activity_page.dart';
import 'package:my_vl/src/pages/hello_page.dart';
import '../services/authentication.dart';
import 'auth_screen.dart';

class RootPage extends StatefulWidget {
  RootPage({@required this.auth});
  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.notDetermined;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notDetermined:
        return _waitingScreen();
        break;
      case AuthStatus.notSignedIn:
        return HelloPage(
          onSignedIn: _onSignedIn,
        );
        break;
      case AuthStatus.signedIn:
        return ActivityPage(
          auth: widget.auth,
          onSignedOut: _onSignedOut,
        );
        break;
    }
  }

  void _onSignedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _onSignedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
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