import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';

class AuthProvider extends InheritedWidget {
  
  AuthProvider({Key key, Widget child, @required this.auth}) : super(key: key, child: child);
  final AuthBase auth;

  @override
  bool updateShouldNotify(_) => true;

  // La fonction of est une fonction statique qui renvoie un objet de type AuthProvider
  // of() prend comme argument le contexte du widget sur laquelle la elle est appelée.
  // Elle trouve le premier Widget de type AuthProvider qu'elle rencontrera
  // en remontant la hiérarchie des widgets.
  // 'as provider' indique à dart que le widget renvoyé va être de type Provider.
  // Ainsi, of() peut retourner la propriété le AuthProvider trouvé et donner accès à l'auth

  static AuthProvider of(BuildContext context) {
    return (context.ancestorWidgetOfExactType(AuthProvider) as AuthProvider);
  }
}