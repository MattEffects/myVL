import 'package:flutter/material.dart';

// Définition de l'interface d'un Bloc
abstract class BlocBase {
  void dispose();
}

// Widget qui va nous permettre d'avoir accès à un Bloc
// depuis n'importe lequel de ses widgets descendants dans la hiérarchie
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

  // La fonction of est une fonction statique qui renvoie un objet de type BlocProvider<T>
  // of() prend comme argument le contexte du widget sur laquelle la elle est appelée.
  // Elle trouve le premier Widget de type BlocProvider<T> qu'elle rencontrera
  // en remontant la hiérarchie des widgets.
  // 'as provider' indique à dart que le widget renvoyé va être de type Provider.
  // Ainsi, of() peut retourner le bloc de type T du BlocProvider trouvé

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
