import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/pages/activity_page.dart';
import 'package:my_vl/src/pages/hello_page.dart';
import 'package:my_vl/src/pages/id_screen.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/models/user_model.dart';

// Page à la racine de notre application
// Gère les écrans à afficher en fonction de l'état de l'application :
// (1) Si un utilisateur Firebase est connecté et a un profil personnalisé
//     dans la base de donnée Firestore
//       => Retourne ActivityPage()
// (2) Si un utilisateur Firebase est connecté mais n'a pas de profil
//     personnalisé dans la base de donnée Firestore
//       => Retourne IdScreen()
// (3) Si un utilisateur Firebase est connecté mais me lien avec
//     la base de donnée Firestore est en cours
//       => Retourne _waitingScreen()
// (4) Si aucun utilisateur n'est connecté
//       => Retourne HelloScreen()

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instance du service d'authentification de l'application
    final AuthBase auth = AuthProvider.of(context).auth;
    // Instance de la base de données Firestore
    final Firestore firestore = Firestore.instance;
    // Référence au bloc de State de l'application
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    // Premier StreamBuilder()
    // Ecoute le Stream témoignant de changements de l'état de connexion 
    // de l'utilisateur Firebase
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> userAuthSnapshot) {
        // Si un utilisateur est connecté, le snapshot renvoyé contient un objet FirebaseUser()
        final bool isSignedIn = userAuthSnapshot.hasData;
        if (isSignedIn) {
          FirebaseUser user = userAuthSnapshot.data;
          // Second StreamBuilder()
          // Ecoute le Stream témoignant du contenu de la collection "users" de Firestore,
          // c'est à dire les profils utilisateurs étendus ayant été créés par l'application
          return StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('users').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> usersDataSnapshot) {
                // Teste la connexion avec les informations de la collection
                if (usersDataSnapshot.hasData) {

                  // Teste l'existence de documents dans la collection "users"
                  if(usersDataSnapshot.data.documents.length != 0) {
                    // On assigne à la variable userDoc l'unique document
                    // qui a le même id que l'utilisateur
                    // ou null si aucun document ne répond à ce critère
                    DocumentSnapshot userDoc = usersDataSnapshot.data.documents.singleWhere((document) {
                      return (document.documentID == user.uid);
                    },
                    orElse: () => null);
                    
                    // Si un document est trouvé :
                    // (1) Change le state de l'application en lui envoyant un StudentUser
                    //     correspondant à l'utilisateur actif
                    // (2) Retourne l'ActivityPage()
                    if (userDoc != null) {
                      bloc.changeActiveUser(StudentUser.fromFirestoreDocument(userDoc, user));
                      return ActivityPage();
                    }
                  }

                  // Si aucun document n'est trouvé :
                  // Retourne l'IdScreen()
                  return IdScreen();

                }
                // Si la connexion avec la base de données n'est pas effective :
                // Retourne un écran de chargement _waitingScreen()
                return _waitingScreen();
              },
          );

        }
        // Si aucun utilisateur Firebase n'est connecté
        return HelloPage();
      },

    );
  }

  // Retourne un écran de chargement
  // (Appelée par le 2e StreamBuilder() de build())
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
