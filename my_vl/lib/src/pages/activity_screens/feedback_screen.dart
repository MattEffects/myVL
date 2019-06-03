import 'package:flutter/material.dart';

enum Destination {
  CVL,
  DELEGUES,
  DEVS,
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Destination _destination = Destination.CVL;
  String t = "Vous n'êtes pas anonyme";
  bool checkBoxState = false;
  final _formKey = GlobalKey<FormState>();



  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: checkBoxState,
          onChanged: (value) {
            setState(() {
             checkBoxState = value; 
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buttonRow(),
              _body(),
              _submit(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            child: Text(
              'CVL',
              style: TextStyle(
                fontSize: 18,
                decoration: (_destination == Destination.CVL)
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination(Destination.CVL),
            textColor: (_destination == Destination.CVL)
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          FlatButton(
            child: Text(
              'Délégués',
              style: TextStyle(
                fontSize: 18,
                decoration: (_destination == Destination.DELEGUES)
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination(Destination.DELEGUES),
            textColor: (_destination == Destination.DELEGUES)
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          FlatButton(
            child: Text(
              'Devs',
              style: TextStyle(
                fontSize: 18,
                decoration: (_destination == Destination.DEVS)
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination(Destination.DEVS),
            textColor: (_destination == Destination.DEVS)
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
        ],
      ),
    );
  }

 Widget _body() {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                _titelfield(),
                SizedBox(height: 50),
                _messagefield(),
                SizedBox(height: 40),
                _anonymous(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                )
              ],
            ),
          )
    )
    );
  }

  Widget _titelfield() {
    return TextFormField(
      minLines: 1,
      maxLines: 1,
        decoration: InputDecoration (
          labelText: 'Titre du message'
        ),
            validator: (value) {
              if (value.isEmpty) {
              return 'Entrez du texte'; 
              }
            }
    );
  }
  
         
  Widget _messagefield() {
    return TextFormField( 
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration (
          labelText: 'Votre message'
        ),
        validator: (value) {
          if (value.isEmpty) { 
            return 'Entrez du texte';
          }
        },
      );
  }       

 
  Widget _anonymous() {  
              return Row(
                children: <Widget>[
                  Checkbox (
                    onChanged: (bool e) => something(), 
                    value: checkBoxState),
                    Text (t),
                ],
                  );
  }

  Widget _submit() { 
    return RaisedButton(
            child: Text('Envoyer'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Merci de votre investissement !')));
                }
              }
            );
  }

void something() { 
  setState(() { 
    if (checkBoxState) { 
      t = "Vous n'êtes pas anonyme";
      checkBoxState = !checkBoxState;
    } else { 
      t = "Vous êtes anonyme";
      checkBoxState = !checkBoxState;
    }
    }
  ); 
}

void _toggleDestination(Destination destination) {
    setState(() => _destination = destination);}


}

  


