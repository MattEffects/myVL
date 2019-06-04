import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/pages/root_page.dart';

// Notre application
class App extends StatelessWidget {
  // Création du bloc de gestion du GlobalState de l'application
  final StateBloc bloc = StateBloc();
  // Référence au service d'authentification de l'application
  final AuthBase auth = Auth();
  @override
  Widget build(BuildContext context) {
    // Création d'un BlocProvider() qui donne accès au bloc
    // à toute sa descendance
    return BlocProvider<StateBloc>(
      bloc: bloc,
      // Création d'un AuthProvider() qui donne accès au
      // service d'authentification à toute sa descendance
      child: AuthProvider(
        auth: auth,
        // StreamBuilder qui gère le mode nuit
        child: StreamBuilder(
          initialData: false,
          stream: bloc.darkMode,
          builder: (context, snapshot) {
            return MaterialApp(
              theme: snapshot.data ? ThemeData.dark() : ThemeData(),
              debugShowCheckedModeBanner: false,
              title: 'MyVL',
              home: RootPage(),
            );
          }
        ),
      ),
    );
  }
}
