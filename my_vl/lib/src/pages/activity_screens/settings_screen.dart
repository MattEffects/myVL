import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
        iconTheme: IconTheme.of(context).copyWith(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      // TODO: Seulement pour faciliter le développement
      body: Center(
        child: FlatButton.icon(
          icon: Icon(Icons.delete),
          label: Text('Supprimer le compte'),
          textColor: Colors.white,
          color: Colors.red,
          onPressed: _deleteAccount,
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    Firestore _firestore = Firestore.instance;
    AuthBase _auth = AuthProvider.of(context).auth;
    StudentUser _user = await BlocProvider.of<StateBloc>(context).activeUser;
    await showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text('Suppression de votre compte'),
          content: Text('$_user, souhaitez-vous réellement supprimer votre compte ?\n\nCette action est irréversible.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context2).pop(),
            ),
            FlatButton(
              textColor: Colors.red[400],
              child: Text('Continuer'),
              onPressed: () async {
                FirebaseUser user = await _auth.currentUser();
                // Supprime le compte de l'utilisateur connecté
                try {
                  final StorageReference _storageRef = FirebaseStorage.instance.ref().child('/profile_photos/${user.uid}.png');
                  _storageRef.delete();
                  _firestore.collection('users').document('${user.uid}').delete();
                  user.delete();
                  BlocProvider.of<StateBloc>(context).changeActiveUser(null);
                  Navigator.of(context2).pop();
                } 
                on PlatformException {
                  Navigator.of(context2).pop();
                  print('wow');
                  showDialog(
                    context: context,
                    builder: (context3) {
                      return AlertDialog(
                        title: Text('Délai dépassé'),
                        content: Text('Vous ne pouvez pas supprimer votre compte en raison d\'un trop long délai entre votre reqûete et votre dernière connexion.\nVous allez être redirigé vers l\'écran de bienvenue.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Annuler"),
                            onPressed: () => Navigator.of(context3).pop(),
                          ),
                          FlatButton(
                            child: Text("Ok"),
                            onPressed: () {
                              _auth.signOut();
                              Navigator.of(context3).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                }
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    Navigator.of(context).pop();
  }
}