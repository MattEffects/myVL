import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/models/user_model.dart';

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
  // Clé référant à notre formulaire
  final _formKey = GlobalKey<FormState>();
  bool checkBoxState = false;
  // Gère la validation auto des champs du formulaire
  bool _autovalidate = false;
  String title = '';
  String message = '';
  String _destination = 'CVL';
  String t = "Vous n'êtes pas anonyme";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buttonRow(),
            _body(),
          ],
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
                decoration:
                    (_destination == 'CVL') ? TextDecoration.underline : null,
              ),
            ),
            shape: StadiumBorder(),
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
            shape: StadiumBorder(),
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
                decoration:
                    (_destination == 'DEVS') ? TextDecoration.underline : null,
              ),
            ),
            shape: StadiumBorder(),
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
                  _titleField(),
                  SizedBox(height: 20),
                  _messageField(),
                  SizedBox(height: 20),
                  _showHintMessage(),
                  _anonymousCheckbox(),
                  SizedBox(height: 20),
                  _submitButton(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                  // )
                ],
              ),
            )));
  }

  Widget _titleField() {
    return TextFormField(
      minLines: 1,
      maxLines: 1,
      autofocus: false,
      autocorrect: true,
      autovalidate: _autovalidate,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Titre du message',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Merci de renseigner un titre';
        }
        return null;
      },
      onSaved: (value) => title = value,
    );
  }

  Widget _messageField() {
    return TextFormField(
      minLines: 5,
      maxLines: 10,
      autofocus: false,
      autocorrect: true,
      autovalidate: _autovalidate,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: 'Votre message'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Votre message ne peut pas être vide';
        }
        return null;
      },
      onSaved: (value) => message = value,
    );
  }

  Widget _anonymousCheckbox() {
    return Row(
      children: <Widget>[
        Checkbox(
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool e) => _toggleCheckboxState(),
            value: checkBoxState),
        GestureDetector(
          child: Text(t),
          onTap: _toggleCheckboxState,
        ),
      ],
    );
  }

  void _toggleCheckboxState() {
    setState(() {
      if (checkBoxState) {
        t = "Vous n'êtes pas anonyme";
        checkBoxState = !checkBoxState;
      } else {
        t = "Vous êtes anonyme";
        checkBoxState = !checkBoxState;
      }
    });
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
    setState(() => _autovalidate = true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Firestore firestore = Firestore.instance;
      StateBloc bloc = BlocProvider.of<StateBloc>(context);
      StudentUser student = await bloc.activeUser;
      try {
        firestore.collection('schools').document(student.school.id).collection('feedbacks').document().setData({
          'title': title,
          'message': message,
          'student':
              checkBoxState ? null : '${student.firstName} ${student.lastName}',
          'studentClassroom': checkBoxState ? null : student.classroomName,
          'studentId': checkBoxState ? null : student.id,
          'destination': _destination
        });
      }
      catch(e) {
        print("$e");
      }
      setState(() => _autovalidate = false);
      _formKey.currentState.reset();
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Merci, votre proposition a été envoyée !')));
    }
  }

  Widget _showHintMessage() {
    if (checkBoxState) {
      return Text(
        'Attention, les administrateurs pourront, en cas d\'abus, accéder à votre identité utilisateur.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.0,
          color: Theme.of(context).primaryColor,
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

  void _toggleDestination(String destination) {
    setState(() => _destination = destination);
  }
}
