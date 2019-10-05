import 'package:flutter/material.dart';
import 'package:my_vl/src/pages/auth_screen.dart';
import 'dart:ui';

// Création de l'écran de bienvenue
// StatefulWidget pour la gestion des animations
class HelloPage extends StatefulWidget {
  @override
  _HelloPageState createState() => _HelloPageState();
}

// Création du State de notre écran de bienvenue
// On joint le mixin permettant de synchroniser nos animations
class _HelloPageState extends State<HelloPage>
    with TickerProviderStateMixin {
  var _bgAnimationDuration = Duration(milliseconds: 200);
  var _mainAnimationDuration = Duration(milliseconds: 300);
  // Initialise l'état de l'écran de bienvenue
  bool _welcomeMode = true;
  Animation<double> _textAlignAnimation;
  Animation<double> _textSizeAnimation;
  Animation<double> _buttonAnimation;
  Animation<double> _blurAnimation;
  AnimationController _mainAnimationController;
  Color _color1 = Colors.red;
  Color _color2 = Colors.orange;

  // Initialisation des contrôleurs de l'animation avec l'initialisation du State
  @override
  void initState() {
    // Appelle la fonction initState de la classe que notre state étend
    super.initState();

    _mainAnimationController = AnimationController(
      duration: _mainAnimationDuration,
      vsync: this,
    );
    _textAlignAnimation = Tween(begin: 0.0, end: -4 / 5).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeIn,
    ));
    _textSizeAnimation = Tween(begin: 60.0, end: 50.0).animate(CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeIn,
    ));
    _blurAnimation = Tween(begin: 5.0, end: 0.0).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeIn,
    ));
    _buttonAnimation = Tween(begin: -50.0, end: 6.0)
        .animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Génère une image de fond
          _backgroundImage(AssetImage('assets/bg_imgs/girl_book_1920.jpg')),
          // Affiche le fond coloré animé avec une opacité modifiable
          _colouredBackground(),
          // Applique un flou animé sur les widgets dessous
          _animatedBlur(animation: _blurAnimation),
          // Affiche le titre et le sous titre animés de l'écran de bienvenue
          _movingLogo(
            title: 'MyVL',
            subtitle: 'Connect. Speak. Grow.',
            animation: _textAlignAnimation,
          ),
          // Permet la détection d'interactions utilisateurs
          // avec l'entièreté de l'écran de bienvenue
          Positioned.fill(
            child: GestureDetector(
              // Applique la fonction onTap après un 'tap' de l'utilisateur
              onTap: _onTap,
            ),
          ),
          // Affiche le bouton d'inscription
          _startButton(),
        ],
      ),
    );
  }

  Widget _backgroundImage(image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
      ),
    );
  }

  // Retourne un fond dégradé
  // dont les couleurs changent lors d'un clic
  // (Appelée par build())
  Widget _colouredBackground({double opacity = 0.35}) {
    return Opacity(
      opacity: opacity,
      // L'AnimatedCntainer
      child: AnimatedContainer(
        duration: _bgAnimationDuration,
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_color1, _color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
  // Retourne un filtre de flou
  // dont l'intensité s'anime lors d'un clic
  // (Appelée par build())
  Widget _animatedBlur({@required Animation<double> animation}) {
    // L'AnimatedBuilder anime le widget dans la propriété 'builder:'
    // en fonction d'une animation définie au préalable
    return AnimatedBuilder(
        animation: animation,
        child: Container(
          color: Colors.black.withOpacity(0),
        ),
        builder: (context, child) {
          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value, sigmaY: _blurAnimation.value),
              child: child,
            ),
          );
        });
  }
  // Retourne le logo
  // dont la position s'anime lors d'un clic
  // (Appelée par build())
  Widget _movingLogo(
      {@required Animation<double> animation,
      @required String title,
      @required String subtitle}) {
    // L'AnimatedBuilder anime le widget dans la propriété 'builder:'
    // en fonction d'une animation définie au préalable
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, _textAlignAnimation.value),
          child: Hero(
            tag: 'TextLogo',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _textSizeAnimation.value,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: _textSizeAnimation.value / 4,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Retourne le bouton "S'inscrire"
  // dont la position s'anime lors d'un clic
  // (Appelée par build())
  Widget _startButton() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: _buttonAnimation.value,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Commencer'),
              textColor: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              // Appelle la fonction _start() pour ouvrir la page AuthScreen()
              onPressed: _start,
            ),
          ),
        );
      }
    );
  }

  // Bascule vers la page AuthScreen()
  // (Appelée par _startButton())
  void _start() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation, animation2) {
          return AuthScreen();
        },
        transitionsBuilder: (context, animation, animation2, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(animation2),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // Exécute les animations
  // (Appelée par le GestureDetector de build())
  _onTap() {
    if (_welcomeMode || !_welcomeMode) {
      setState(() {
        _color1 = (_color1 == Colors.red) ? Colors.blue[600] : Colors.red;
        _color2 = (_color2 == Colors.orange) ? Colors.lightBlue[200] : Colors.orange;
        if (_mainAnimationController.status == AnimationStatus.completed) {
          _mainAnimationController.reverse();
          _welcomeMode = true;
        } else {
          _mainAnimationController.forward();
          _welcomeMode = false;
        }
      });
    }
  }
}
