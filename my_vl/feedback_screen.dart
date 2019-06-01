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
  bool _isAnonymous = false;
  final _formKey = GlobalKey<FormState>();

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
              _formRow(),
              _formRowbis(),
              _body(), 
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
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _formRow(),
                SizedBox(height: 20),
              ],
            ),
          )
    );
  }

  Widget _formRow() {
    SizedBox(height: 10);
    Text(
      'Titre',
    );
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),


  Widget _formRowbis() {
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            minLines: 8,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Chargement ...')));
                }
              },
              child: Text('Envoyer'),
            ),
          ),
        ],
      );
    }

void _toggleDestination(Destination destination) {
    setState(() => _destination = destination);




