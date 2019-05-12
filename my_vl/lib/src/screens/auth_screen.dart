import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../mixins/validators.dart';
import '../services/authentication.dart';

enum FormMode { LOGIN, SIGNUP } 

class AuthScreen extends StatefulWidget {
  AuthScreen({@required this.auth});
  final BaseAuth auth;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with Validators{
  
  FormMode _formMode = FormMode.SIGNUP; // Mode de l'écran
  bool _isLoading = false; // Statut de l'application (chargement ou non)
  bool _autovalidate = false; // Gère la validation auto des champs du formulaire
  bool _obscure = true; // Gère le masquage du mot de passe
  var _formKey = GlobalKey<FormState>(); // Clé référant à notre formulaire
  String _email = '';
  String _password = '';
  String _confirmedPassword = '';
  String _errorMessage = '';

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: _formMode == FormMode.SIGNUP ? Text('Rejoindre MyVL') : Text('Se connecter'),
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return Center(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _showLogo(),
                SizedBox(height: 20),
                _showErrorMessage(_errorMessage),
                SizedBox(height: 20),
                _emailField(),
                SizedBox(height: 15),
                _passwordField(),
                _formMode == FormMode.SIGNUP ? _confirmPasswordField() : SizedBox(),
                SizedBox(height: 45),
                _submitButton(),
                SizedBox(height: 20),
                _switchButton(),
              ],
            ),
          )),
    );
  }

  // Se charge de vérifier nos conditions de validation de saisie
  // Les sauvegarde dans les variables prévues à cet effet
  // Et renvoie true ou false
  bool validateAndSave() {
    setState(() {
      _autovalidate = true;
      _errorMessage = '';
      });
    // Lance la validation du formulaire
    if (_formKey.currentState.validate()) {
      // Si valide, enregistre le formulaire dans les variables
      _formKey.currentState.save();
      // Vérifie que les mots de passe correspondent si en SIGNUP mode
      if (_password == _confirmedPassword || _formMode == FormMode.LOGIN) {
        return true;
      }
      else {
        setState(() {
          _errorMessage = 'Les mots de passe ne correspondent pas';
        });
        return false;
      }
    }
    return false;
  }

  // Envoie les informations à Firebase
  // Nous indique si le login/signup à réussi
  // Et nous retourne une erreur si ce n'est pas le cas
  void submit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
        _autovalidate = false;
      });
      print('Email is : $_email\nPassword is : $_password');
      try {
        if (_formMode == FormMode.LOGIN) {
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Connecté : $userId');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Félicitations !'),
                content: Text('Vous vous êtes connecté avec succès. \nVotre ID est $userId'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text('Continuer'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/activity');
                    },
                  ),
                ],
              );
            },
          );
        }
        else {
          String userId = await widget.auth.signUpWithEmailAndPassword(_email, _password);
          print('Inscrit : $userId');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Félicitations !'),
                content: Text('Vous vous êtes inscrit avec succès. \n Votre ID est $userId'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text('Continuer'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/activity');
                    },
                  ),
                ],
              );
            },
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
      catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    setState(() {
      _formMode = FormMode.SIGNUP;
      _autovalidate = false;
      _obscure = true;
      _errorMessage = '';
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formMode = FormMode.LOGIN;
      _autovalidate = false;
      _obscure = true;
      _errorMessage = '';
    });
  }

  Widget _showLogo() {
    return Hero(
      tag: 'TextLogo',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'MyVL',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Connect. Speak. Grow.',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 50 / 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      autocorrect: false,
      autovalidate: _autovalidate,
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        labelText: 'Email',
      ),
      onSaved: (value) => _email = value,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      autocorrect: false,
      obscureText: _obscure,
      autovalidate: _autovalidate,
      validator: validatePassword,
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          icon: (_obscure)
              ? Icon(Icons.visibility_off, color: Colors.grey)
              : Icon(Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        labelText: 'Mot de passe',
        helperText: '8-24 caractères, majuscules et minuscules',
      ),
      onSaved: (value) => _password = value,
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      autocorrect: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(
          Icons.verified_user,
          color: Colors.grey,
        ),
        labelText: 'Confirmer le mot de passe',
      ),
      onSaved: (value) => _confirmedPassword = value,
    );
  }

  Widget _submitButton() {
    return FlatButton.icon(
      icon: Icon(Icons.person),
      label: _formMode == FormMode.SIGNUP
        ? Text('S\'inscrire')
        : Text('Se connecter')
      ,
      textColor: Colors.white,
      color: Colors.blue,
      highlightColor: Colors.blue[400],
      disabledColor: Colors.grey[200],
      onPressed: submit,
    );
  }

  Widget _switchButton() {
    return Text.rich(
      TextSpan(
        text: _formMode == FormMode.LOGIN 
          ? 'Pas de compte ? '
          : 'Déjà un compte ? ',
        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
        children: <TextSpan>[
          TextSpan(
            text: _formMode == FormMode.LOGIN 
              ? 'Inscrivez vous !'
              : 'Connectez vous !',
            style: TextStyle(decoration:TextDecoration.underline,),
            recognizer: TapGestureRecognizer()
                  ..onTap = _formMode == FormMode.SIGNUP
                    ? _changeFormToLogin
                    : _changeFormToSignUp,
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _showErrorMessage(String error) {
    if (error.length > 0 && error != null) {
      return Text(
        error,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    }
    else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0,);
  }

}
