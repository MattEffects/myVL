import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// class StateProvider extends InheritedWidget {
//   
//   StateProvider({Key key, Widget child, @required this.bloc}) : super(key: key, child: child);
//   final StateBloc bloc;
// 
//   @override
//   bool updateShouldNotify(_) => true;
// 
//   static StateProvider of(BuildContext context) {
//     return (context.inheritFromWidgetOfExactType(StateProvider) as StateProvider);
//   }
// 
//   // La fonction of est une fonction statique qui renvoie un objet de type AuthProvider
//   // of() prend comme argument le contexte du widget sur laquelle la elle est appelée.
//   // Elle trouve le premier Widget de type AuthProvider qu'elle rencontrera
//   // en remontant la hiérarchie des widgets.
//   // 'as provider' indique à dart que le widget renvoyé va être de type Provider.
//   // Ainsi, of() peut retourner la propriété le AuthProvider trouvé et donner accès à l'auth
// }