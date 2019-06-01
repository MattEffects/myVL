import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import '../blocs/state_bloc.dart';
import '../services/authentication.dart';
import '../mixins/validators.dart';
import '../models/school_model.dart';
import '../models/user_model.dart';

class IdScreen extends StatefulWidget {
  @override
  _IdScreenState createState() => _IdScreenState();
}

class _IdScreenState extends State<IdScreen> with Validators {
  bool _isLoading = false; // Statut de l'application (chargement ou non)
  final _formKey = GlobalKey<FormState>(); // Clé référant à notre formulaire
  final Firestore firestore = Firestore.instance;
  bool _autovalidate = false; // Gère la validation auto des champs du formulaire
  var _spacing;
  String _firstName = '';
  String _lastName = '';
  School _school;
  Classroom _classroom;
  String _level;
  String _pathway;
  String _speciality;
  String _errorMessage = '';
  int _schoolIndex;
  int _classroomIndex;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _spacing = MediaQuery.of(context).size.width/30;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes informations',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: Theme.of(context).primaryColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('schools').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var schools = snapshot.data.documents.map((school){
              return School.fromJson(school.data);
            }).toList();
            return Stack(
              children: <Widget>[
                _showBody(schools),
                _showProgress(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  Widget _showBody(schools) {
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
              _nameFields(),
              SizedBox(height: _spacing),
              _schoolField(schools),
              SizedBox(height: _spacing),
              _classroomField(schools),
              SizedBox(height: _spacing*2),
              _submitButton(),
              // SizedBox(height: _spacing),
              _cancelButton(),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _validateAndSave() async {
    setState(() {
      _autovalidate = true;
      _errorMessage = '';
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool studentExists = false;
      try {
        studentExists = (
        _classroom.students.singleWhere(
          (student) {
            if (student.firstName == _firstName && student.lastName == _lastName) {
              setState(() => _speciality = student.speciality);
              return true;
            }
            return false;
          },
          orElse: () => null,
          ) != null
        );
      } catch(e) {
        setState(() {
          _speciality = null;
          _errorMessage = 'Plusieurs élèves portent ce nom dans la ${_classroom.name} \n Merci de vous adresser à votre établissement';
        });
        return false;
      }
      if (studentExists) {
        return true;
      } else {
        setState(() {
          _errorMessage = 'Aucun élève à votre nom n\'a été trouvé dans la ${_classroom.name}';
        });
        return false;
      }
    }
    return false;
  }

  void _submit() async {
    final AuthBase auth = AuthProvider.of(context).auth;
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    bool valid = await _validateAndSave();
    if (valid) {
      setState(() {
        _autovalidate = false;
      });
      FirebaseUser activeFireUser = await auth.currentUser();
      setState(() => _isLoading = true);
      await firestore.collection('users').document('${activeFireUser.uid}').setData(
        {'firstName': _firstName,
        'lastName': _lastName,
        'displayName': '$_firstName $_lastName',
        'email': activeFireUser.email,
        'isEmailVerified': activeFireUser.isEmailVerified,
        'photoUrl': activeFireUser.photoUrl,
        'schoolName': _school.name,
        'classroomName': _classroom.name,
        'level': _level,
        'pathway': _pathway,
        'speciality': _speciality},
        merge: false,
      );
      bloc.activeUser.listen((user) => print(user.displayName));
      // StudentUser activeStudentUser = StudentUser(
      //   id: activeFireUser.uid,
      //   firstName: _firstName,
      //   lastName: _lastName,
      //   email: activeFireUser.email,
      //   photoUrl: activeFireUser.photoUrl,
      //   school: _school,
      //   classroom: _classroom,
      //   speciality: _speciality,
      //   firebaseUser: activeFireUser,
      // );
      // bloc.changeActiveUser(activeStudentUser);
      // print(activeStudentUser.toStringDebug());
    }
  }

  Widget _nameFields() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: _firstNameField(),),
        SizedBox(width: _spacing),
        Expanded(child: _lastNameField(),),
      ],
    );
  }

  Widget _firstNameField() {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      autocorrect: false,
      autovalidate: _autovalidate,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Prénom',
      ),
      validator: validateFirstName,
      onSaved: (value) => _firstName = value,
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      autocorrect: false,
      autovalidate: _autovalidate,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nom',
        filled: true,
      ),
      validator: validateLastName,
      onSaved: (value) => _lastName = value,
    );
  }

  Widget _schoolField(List<School> schools) {
    return DropdownButtonFormField(
      items: schools.map((School school) {
        return DropdownMenuItem<int>(
          value: schools.indexOf(school),
          child: Text('$school'),
        );
      }).toList(),
      value: _schoolIndex,
      onChanged: (value) {
        setState(() {
          _classroomIndex = null;
          _schoolIndex = value;
        });
      },
      validator: validateSchool,
      onSaved: (value) => _school = schools[value],
      hint: Text('Établissement'),
      decoration: InputDecoration(
        labelText: (_schoolIndex != null) ? 'Établissement' : '',
        filled: true,
      ),
    );
  }

  Widget _classroomField(List<School> schools) {
    var classrooms = (_schoolIndex != null) ? schools[_schoolIndex].classrooms : [];
    return DropdownButtonFormField(
      items: (classrooms.length != 0) ? classrooms.map((classroom) {
        return DropdownMenuItem(
          value: classrooms.indexOf(classroom),
          child: Text('$classroom'),
        );
      }).toList() : null,
      value: _classroomIndex,
      onChanged: (value) {
        setState(() {
          _classroomIndex = value;
        });
      },
      validator: validateClassroom,
      onSaved: (value) {
        _classroom = classrooms[value];
        _level = _classroom.level;
        _pathway = _classroom.pathway;
      },
      hint: Text('Classe'),
      decoration: InputDecoration(
        labelText: (_classroomIndex != null) ? 'Classe' : '',
        filled: true,
      ),
    );
  }

  Widget _submitButton() {
    return MaterialButton(
      child: Text(
        'Terminer l\'inscription',
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

  Widget _cancelButton() {
    final AuthBase auth = AuthProvider.of(context).auth;
    return MaterialButton(
      child: Text(
        'Annuler',
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Annuler l\'inscription'),
              content: Text('Souhaitez-vous réellement annuler la procédure d\'inscription ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Annuler'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  textColor: Colors.red[400],
                  child: Text('Continuer'),
                  onPressed: () async {
                    FirebaseUser user = await auth.currentUser();
                    setState(() => _isLoading = true);
                    await user.delete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
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
