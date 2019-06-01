import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_vl/src/models/school_model.dart';
import 'package:my_vl/src/pages/activity_page.dart';
import 'package:my_vl/src/pages/hello_page.dart';
import 'package:my_vl/src/pages/id_screen.dart';
import '../blocs/auth_provider.dart';
import '../services/authentication.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/state_bloc.dart';
import '../models/user_model.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBase auth = AuthProvider.of(context).auth;
    final Firestore firestore = Firestore.instance;
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> userAuthSnapshot) {
        final bool isSignedIn = userAuthSnapshot.hasData;

        if (isSignedIn) {
          FirebaseUser user = userAuthSnapshot.data;
          return StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('users').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> usersDataSnapshot) {

                if (usersDataSnapshot.hasData) {

                  if(usersDataSnapshot.data.documents.length != 0) {
                    DocumentSnapshot userDoc = usersDataSnapshot.data.documents.singleWhere((document) {
                      return (document.documentID == user.uid);
                    },
                    orElse: () => null);
                    if (userDoc != null) {
                      print('${userDoc.documentID} ${user.uid}');
                      bloc.changeActiveUser(StudentUser.fromDocument(userDoc, user));
                      return ActivityPage();
                    }
                    // else if (usersDataSnapshot.data.documentChanges.length != 0) {
                    //   userDoc = usersDataSnapshot.data.documentChanges[0].document;
                    //   bloc.changeActiveUser(StudentUser.fromDocument(userDoc, user));
                    //   return ActivityPage();
                    // }
                  }
                  return IdScreen();
                }

                return _waitingScreen();
              },
          );
        }

        return HelloPage();
      },
    );
  }

  Widget _waitingScreen() {
    return Scaffold(
      body: Container(
        // color: Colors.red,
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
