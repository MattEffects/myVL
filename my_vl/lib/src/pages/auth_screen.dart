import 'package:flutter/material.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/mixins/validators.dart';
import 'package:my_vl/src/services/authentication.dart';

enum FormMode { LOGIN, SIGNUP }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with Validators {
  FormMode _formMode = FormMode.SIGNUP; // Mode de l'écran
  bool _isLoading = false; // Statut de l'application (chargement ou non)
  bool _autovalidate = false; // Gère la validation auto des champs du formulaire
  bool _obscure = true; // Gère le masquage du mot de passe
  var _formKey = GlobalKey<FormState>(); // Clé référant à notre formulaire
  var _spacing;
  String _email = '';
  String _password = '';
  String _confirmedPassword = '';
  String _errorMessage = '';

  @override
  Widget build(context) {
    setState(() {
      _spacing = MediaQuery.of(context).size.width/30;
    });
    return Scaffold(
      appBar: AppBar(
        title: _formMode == FormMode.SIGNUP
            ? Text(
              'Rejoindre MyVL',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
            : Text(
              'Se connecter',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: Theme.of(context).primaryColor),
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
              SizedBox(height: _spacing*2),
              _showErrorMessage(_errorMessage),
              SizedBox(height: (_errorMessage.length != 0) ? _spacing : 0),
              _emailField(),
              SizedBox(height: _spacing),
              _passwordField(),
              _formMode == FormMode.SIGNUP
                  ? SizedBox(height: _spacing)
                  : SizedBox(),
              _formMode == FormMode.SIGNUP
                  ? _confirmPasswordField()
                  : SizedBox(),
              SizedBox(height: 25),
              _submitButton(),
              _switchButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Se charge de vérifier nos conditions de validation de saisie
  // Les sauvegarde dans les variables prévues à cet effet
  // Et renvoie true ou false
  bool _validateAndSave() {
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
      } else {
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
  void _submit() async {
    final AuthBase auth = AuthProvider.of(context).auth;
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
        _autovalidate = false;
      });
      print('Email is : $_email\nPassword is : $_password');
      try {
        if (_formMode == FormMode.LOGIN) {
          String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Connecté : $userId');
        } else {
          String userId =
              await auth.signUpWithEmailAndPassword(_email, _password);
          print('Inscrit : $userId');
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (e) {
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

  Widget _showErrorMessage(String error) {
    if (error.length > 0 && error != null) {
      return Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
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
              fontFamily: "Roboto",
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            'Connect. Speak. Grow.',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 50 / 4,
              fontWeight: FontWeight.bold,
              fontFamily: "Roboto",
              decoration: TextDecoration.none,
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
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        labelText: 'Email',
        filled: true,
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
        prefixIcon: Icon(
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
        filled: true,
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
        prefixIcon: Icon(
          Icons.verified_user,
          color: Colors.grey,
        ),
        labelText: 'Confirmer le mot de passe',
        filled: true,
      ),
      onSaved: (value) => _confirmedPassword = value,
    );
  }

  Widget _submitButton() {
    return MaterialButton(
      child: Text(
        (_formMode == FormMode.SIGNUP) 
          ? 'S\'inscrire'
          : 'Se connecter',
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.subhead.fontSize,
        ),
      ),
      height: 42.0,
      minWidth: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      onPressed: _submit,
    );
  }

  Widget _switchButton() {
    return MaterialButton(
      child: Text(
        _formMode == FormMode.LOGIN
            ? 'Pas de compte ?'
            : 'Déjà un compte ?',
        style: TextStyle(
          color: Theme.of(context).disabledColor,
        ),
      ),
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Colors.transparent,
      height: 42.0,
      minWidth: MediaQuery.of(context).size.width,
      // highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      onPressed: _formMode == FormMode.SIGNUP
        ? _changeFormToLogin
        : _changeFormToSignUp,
    );
  }

  Widget _showProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
