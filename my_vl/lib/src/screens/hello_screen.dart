import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// Création de l'écran de bienvenue
// StatefulWidget pour la gestion des animations
class HelloScreen extends StatefulWidget {
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

// Création du State de notre écran de bienvenue
// On joint le mixin permettant de synchroniser nos animations
class _HelloScreenState extends State<HelloScreen>
    with TickerProviderStateMixin {
  var _bgAnimationDuration = Duration(milliseconds: 200);
  var _mainAnimationDuration = Duration(milliseconds: 300);
  // Initialise l'état de l'écran de bienvenue
  bool welcomeMode = true;
  Animation<double> textAlignAnimation;
  Animation<double> textSizeAnimation;
  Animation<double> buttonAnimation;
  Animation<double> blurAnimation;
  AnimationController mainAnimationController;
  Color color1 = Colors.red;
  Color color2 = Colors.orange;

  @override
  void initState() {
    super.initState();

    mainAnimationController = AnimationController(
      duration: _mainAnimationDuration,
      vsync: this,
    );
    textAlignAnimation = Tween(begin: 0.0, end: -4 / 5).animate(CurvedAnimation(
      parent: mainAnimationController,
      curve: Curves.easeIn,
    ));
    textSizeAnimation = Tween(begin: 60.0, end: 50.0).animate(CurvedAnimation(
        parent: mainAnimationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        )));
    blurAnimation = Tween(begin: 5.0, end: 0.0).animate(CurvedAnimation(
      parent: mainAnimationController,
      curve: Curves.easeIn,
    ));
  }

  getSize(GlobalKey key) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    double minButtonPosition = -50.0;
    double maxButtonPosition = 6.0;
    buttonAnimation = Tween(begin: minButtonPosition, end: maxButtonPosition)
        .animate(CurvedAnimation(
      parent: mainAnimationController,
      curve: Curves.easeIn,
    ));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Génère une image de fond
          _backgroundImage(AssetImage('assets/bg_imgs/girl_book.jpg')),
          // Affiche le fond coloré animé avec une opacité modifiable
          _colouredBackground(),
          // Applique un flou animé sur les widgets dessous
          _animatedBlur(animation: blurAnimation),
          // Affiche le titre et le sous titre animés de l'écran de bienvenue
          _movingText(
            title: 'MyVL',
            subtitle: 'Connect. Speak. Grow.',
            animation: textAlignAnimation,
          ),
          // Permet la détection d'interactions utilisateurs
          // avec l'entièreté de l'écran de bienvenue
          Positioned.fill(
            child: GestureDetector(
              // Applique la fonction onTap après un 'tap' de l'utilisateur
              onTap: onTap,
            ),
          ),
          // Affiche le bouton d'inscription
          _signUpButton(),
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

  Widget _colouredBackground({double opacity = 0.35}) {
    return Opacity(
      opacity: opacity,
      child: AnimatedContainer(
        duration: _bgAnimationDuration,
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _animatedBlur({@required Listenable animation}) {
    return AnimatedBuilder(
        animation: animation,
        child: Container(
          color: Colors.black.withOpacity(0),
        ),
        builder: (context, child) {
          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: blurAnimation.value, sigmaY: blurAnimation.value),
              child: child,
            ),
          );
        });
  }

  Widget _movingText(
      {@required Listenable animation,
      @required String title,
      @required String subtitle}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, textAlignAnimation.value),
          child: Hero(
            tag: 'TextLogo',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textSizeAnimation.value,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: textSizeAnimation.value / 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _signUpButton() {
    return AnimatedBuilder(
        animation: buttonAnimation,
        builder: (context, child) {
          return Positioned(
            bottom: buttonAnimation.value,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('S\'inscrire'),
                textColor: Colors.white,
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
            ),
          );
        });
  }

  onTap() {
    if (welcomeMode || !welcomeMode) {
      setState(() {
        color1 = (color1 == Colors.red) ? Colors.blue : Colors.red;
        color2 = (color2 == Colors.orange) ? Colors.lightBlue : Colors.orange;
        if (mainAnimationController.status == AnimationStatus.completed) {
          mainAnimationController.reverse();
          welcomeMode = true;
        } else {
          mainAnimationController.forward();
          welcomeMode = false;
        }
      });
    }
  }
}
