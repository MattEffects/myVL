import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'blocs/auth_provider.dart';
import 'blocs/state_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'pages/root_page.dart';
import 'pages/activity_page.dart';
import 'pages/activity_screens/restauration_screen.dart';
import 'pages/activity_screens/settings_screen.dart';

class App extends StatelessWidget {
  final StateBloc bloc = StateBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StateBloc>(
      bloc: bloc,
      child: AuthProvider(
        auth: Auth(),
        child: StreamBuilder<dynamic>(
          initialData: false,
          stream: bloc.darkMode,
          builder: (context, snapshot) {
            return MaterialApp(
              theme: snapshot.data ? ThemeData.dark() : ThemeData(),
              debugShowCheckedModeBanner: false,
              title: 'MyVL',
              routes: <String, WidgetBuilder>{
                '/': (BuildContext context) {
                  return RootPage();
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
        ),
      ),
    );
  }
}
