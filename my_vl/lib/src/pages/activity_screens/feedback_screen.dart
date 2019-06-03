import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import '../../models/user_model.dart';

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
  String _destination = 'CVL';
  String t = "Vous n'êtes pas anonyme";
  bool checkBoxState = false;
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String message = '';

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
                decoration: (_destination == 'CVL')
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination('CVL'),
            textColor: (_destination == 'CVL')
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          FlatButton(
            child: Text(
              'Délégués',
              style: TextStyle(
                fontSize: 18,
                decoration: (_destination == 'DELEGUES')
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination('DELEGUES'),
            textColor: (_destination == 'DELEGUES')
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          FlatButton(
            child: Text(
              'Devs',
              style: TextStyle(
                fontSize: 18,
                decoration: (_destination == 'DEVS')
                    ? TextDecoration.underline
                    : null,
              ),
            ),
            onPressed: () => _toggleDestination('DEVS'),
            textColor: (_destination == 'DEVS')
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _titelfield(),
                SizedBox(height: 20),
                _messagefield(),
                SizedBox(height: 20),
                _anonymous(),
                SizedBox(height: 20),
                _submitButton(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                // )
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
          border: OutlineInputBorder(),
          labelText: 'Titre du message',
        ),
            validator: (value) {
              if (value.isEmpty) {
              return 'Entrez du texte'; 
              }
            },
      onSaved: (value) => title = value,
    );
  }
  
         
  Widget _messagefield() {
    return TextFormField( 
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration (
        border: OutlineInputBorder(),
          labelText: 'Votre message'
        ),
        validator: (value) {
          if (value.isEmpty) { 
            return 'Entrez du texte';
          }
        },
      onSaved: (value) => message = value,
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

  Widget _submitButton() { 
    return FlatButton.icon(
            label: Text('Envoyer'),
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
              onPressed: _submit,
            );
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Firestore firestore = Firestore.instance;
      StateBloc bloc = BlocProvider.of<StateBloc>(context);
      StudentUser student = await bloc.activeUser;
      await firestore.collection('feedbacks').document().setData(
        {'title': title,
        'message': message,
        'student': checkBoxState ? null : '${student.firstName} ${student.lastName}',
        'studentClassroom': checkBoxState ? null : student.classroomName,
        'studentId': checkBoxState ? null : student.id,
        'destination': _destination}
      );
      _formKey.currentState.reset();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Merci de votre investissement !')));
    }
  }


void _toggleDestination(String destination) {
    setState(() => _destination = destination);}

}

  


