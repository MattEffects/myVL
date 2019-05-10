import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import '../mixins/validators.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_provider.dart';

enum FormMode { LOGIN, SIGNUP }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with Validators{
  
  FormMode _formMode = FormMode.SIGNUP;
  bool _isLoading = false;
  bool _autovalidate = false;
  bool _obscure = true;
  var _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmedPassword = '';
  String _errorMessage = '';

  Widget build(context) {
    final AuthBloc _bloc = AuthProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: _formMode == FormMode.SIGNUP ? Text('Rejoindre MyVL') : Text('Se connecter'),
      ),
      body: _showBody(context, _bloc),
    );
  }

  Widget _showBody(BuildContext context, AuthBloc bloc) {
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

    // Déroulement complet :
    // 1. A chaque appui de touche, le String entré transite vers 'onChanged'
    // 2. onChanged envoie la valeur au sink.add() de notre '_email' StreamController
    // ~ 3. Le sink envoie cette valeur dans le Stream 'email'
    // ~ 4. Le stream envoie cette valeur au StreamTransformer 'validateEmail'
    // ~ 5. La valeur transformée est renvoyée au Stream 'email'
    // 6. Cette valeur transformée est communiquée au StreamBuilder
    // 7. Le StreamBuilder appelle la fonction 'builder'
    // 8. La valeur est stockée dans le 'snapshot'
    // 9. errorText affiche la valeur 'error' du snapshot (nulle si entrée validée)
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

  Widget _tempoButton(context) {
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
      onPressed: () {
        Navigator.pushNamed(context, '/activity');
      },
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
      onPressed: _submit,
    );
  }

  void _submit() {
    setState(() {
      _autovalidate = true;
      _errorMessage = '';
      });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_password == _confirmedPassword || _formMode == FormMode.LOGIN) {
        print('Email is : $_email\nPassword is : $_password');
        setState(() => _autovalidate = false);
        Navigator.pushNamed(context, '/activity');
      }
      else {
        setState(() {
          _errorMessage = 'Les mots de passe ne correspondent pas';
        });
      }
    }
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

}
