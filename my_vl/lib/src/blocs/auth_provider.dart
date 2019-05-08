import 'package:flutter/material.dart';
import 'auth_bloc.dart';

class AuthProvider extends InheritedWidget {
  final bloc = AuthBloc();

  AuthProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AuthProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider);
  }

  // La fonction of est une fonction statique qui renvoie un objet de type AuthBloc
  // of() prend comme argument le contexte du widget sur laquelle la elle est appelée.
  // Elle trouve le premier Widget de type Provider qu'elle rencontrera
  // en remontant la hiérarchie des widgets.
  // 'as provider' indique à dart que le widget renvoyé va être de type Provider.
  // Ainsi, of() peut retourner la propriété bloc associée au Provider trouvé
}