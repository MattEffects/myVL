import 'package:flutter/material.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  Widget build(context) {
    final AuthBloc _bloc = AuthProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejoindre MyVL'),
      ),
      body: _showBody(context, _bloc),
    );
  }

  Widget _showBody(BuildContext context, AuthBloc bloc) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showLogo(),
                SizedBox(height: 20),
                _errorMessage(bloc),
                SizedBox(height: 20),
                _emailField(bloc),
                SizedBox(height: 15),
                _passwordField(bloc),
                _confirmPasswordField(bloc),
                SizedBox(height: 45),
                _tempoButton(context),
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

  Widget _emailField(AuthBloc bloc) {
    return StreamBuilder(
      // Chaque fois qu'un nouvel évènement passe dans le Stream...
      stream: bloc.email,
      initialData: '',
      // ... le builder est relancé et retourne un nouveau TextField
      // Snapshot contient la donnée qui vient de passer dans le Stream
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          // Lie l'entrée de texte au email.sink.add()
          // Chaque nouveau caractère saisi est envoyé au email stream via sink.add()
          onChanged: bloc.changeEmail,
          maxLines: 1,
          autofocus: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(
              Icons.email,
              color: Colors.grey,
            ),
            labelText: 'Email ${snapshot.data}',
            errorText: snapshot.error,
          ),
        );
      },
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

  Widget _passwordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (BuildContext context, AsyncSnapshot<String> snapshotInput) {
        return StreamBuilder(
          stream: bloc.obscureText,
          initialData: true,
          builder:
              (BuildContext context, AsyncSnapshot<bool> snapshotVisibility) {
            return TextField(
              onChanged: bloc.changePassword,
              maxLines: 1,
              autofocus: false,
              autocorrect: false,
              obscureText: snapshotVisibility.data,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: (snapshotVisibility.data)
                      ? Icon(Icons.visibility, color: Colors.grey)
                      : Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () => bloc.toggle(!snapshotVisibility.data),
                ),
                labelText: 'Mot de passe ${snapshotInput.data}',
                helperText: '8-24 caractères, majuscules et minuscules',
                errorText: snapshotInput.error,
              ),
            );
          },
        );
      },
    );
  }

  Widget _confirmPasswordField(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.confirmPassword,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: bloc.changeConfirmPassword,
            maxLines: 1,
            autofocus: false,
            autocorrect: false,
            obscureText: false,
            decoration: InputDecoration(
              icon: Icon(
                Icons.verified_user,
                color: Colors.grey,
              ),
              labelText: 'Confirmer le mot de passe ${snapshot.data}',
            ),
          );
        });
  }
  Widget _tempoButton(context) {
    return FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Activités'),
            textColor: Colors.white,
            color: Colors.blue,
            highlightColor: Colors.blue[400],
            disabledColor: Colors.grey[200],
            onPressed: () {
              Navigator.pushNamed(context, '/activity');
            },
          );
  }
  Widget _submitButton(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('S\'inscrire ${snapshot.data}'),
            textColor: Colors.white,
            color: Colors.blue,
            highlightColor: Colors.blue[400],
            disabledColor: Colors.grey[200],
            onPressed: (snapshot.hasData && snapshot.data) ? bloc.submit : null,
          );
        });
  }

  Widget _errorMessage(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && !snapshot.data) {
          return Text(
            'Les mots de passe ne correspondent pas',
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
      },
    );
  }
}
