import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/pages/profile_pic_page.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:my_vl/src/mixins/validators.dart';
import 'package:my_vl/src/models/school_model.dart';

// TODO: Implémenter l'utilisation d'un code unique
// permettant de vérifier l'identité de l'élève
// lors de la création du compte

class IdScreen extends StatefulWidget {
  @override
  _IdScreenState createState() => _IdScreenState();
}

class _IdScreenState extends State<IdScreen> with Validators {
  // Statut de l'application (chargement ou non)
  bool _isLoading = false;
  // Clé référant à notre formulaire
  final _formKey = GlobalKey<FormState>();
  // Référence à notre base de données Firestore
  final Firestore firestore = Firestore.instance;
  // Gère la validation auto des champs du formulaire
  bool _autovalidate = false;
  // Donne une valeur de padding en fonction des dimensions de l'écran
  double _spacing;
  // Variables nécessaires à la création d'un StudentUser
  // allant être complétées par le formulaire
  String _firstName = '';
  String _lastName = '';
  School _school;
  Classroom _classroom;
  String _level = '';
  String _pathway = '';
  String _speciality = '';
  String _errorMessage = '';
  // Variables nécessaires temporairement
  // à l'identification des informations Firestore de l'étudiant
  int _schoolIndex;
  int _classroomIndex;

  @override
  Widget build(BuildContext context) {
    // Initialisation de spacing en fonction de la taille de l'écran
    setState(() {
      _spacing = MediaQuery.of(context).size.width / 30;
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
        iconTheme: IconTheme.of(context)
            .copyWith(color: Theme.of(context).primaryColor),
      ),
      // Lien du rendu de l'écran d'identification avec les données de Firestore
      // A chaque modification des données de la collection 'school',
      // le widget sera rendu de nouveau
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('schools').snapshots(),
          builder: (context, snapshot) {
            // Affiche l'écran si des données de Firestore ont été reçues
            if (snapshot.hasData) {
              var schools = snapshot.data.documents.map((school) {
                return School.fromFirestoreDocument(school);
              }).toList();
              return Stack(
                children: <Widget>[
                  // Corps de l'écran
                  _showBody(schools),
                  // Permet la superposition d'un indicateur de chargement
                  _showProgress(),
                ],
              );
            }
            // Affiche un indicateur de chargement en attendant les données de Firestore
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  // Renvoie le corps de l'écran
  // (Appelée par build(), qui rend le widget)
  Widget _showBody(List<School> schools) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Affiche le logo
              _showLogo(),
              SizedBox(height: _spacing * 2),
              // Affiche un message d'erreur indépendant du formulaire si nécessaire
              _showErrorMessage(_errorMessage),
              SizedBox(height: (_errorMessage.length != 0) ? _spacing : 0),
              // Affiche les champs Nom et Prénom en ligne
              _nameFields(),
              SizedBox(height: _spacing),
              // Affiche le sélecteur d'école
              _schoolField(schools),
              SizedBox(height: _spacing),
              // Affiche le sélecteur de classe
              _classroomField(schools),
              SizedBox(height: _spacing * 2),
              // Affiche le bouton de validation
              _submitButton(),
              // Affiche le bouton pour changer le mode du formulaire
              _cancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Crée une entrée dans la base de données 
  // avec toutes les informations de l'utilisateur
  // si le formulaire est validé
  // (Appelée par le _submitButton du formulaire)
  void _submit() async {
    final AuthBase auth = AuthProvider.of(context).auth;
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    // Appelle _validateAndSave() pour valider le formulaire
    if (_validateAndSave()) {
      setState(() {
        _autovalidate = false;
      });
      // Récupération du FirebaseUser pour avoir ses informations à disposition
      FirebaseUser activeFireUser = await auth.currentUser();
      // Informe d'un chargement
      setState(() => _isLoading = true);
      final url = await _manageProfilePic();
      print('storage url : $url');
      print('user url before reload : ${activeFireUser.photoUrl}');
      await activeFireUser.reload();
      activeFireUser = await auth.currentUser();
      print('user url after re-assign : ${activeFireUser.photoUrl}');
      await firestore
          .collection('users')
          .document('${activeFireUser.uid}')
          .setData(
        {
          'firstName': _firstName,
          'lastName': _lastName,
          'displayName': '$_firstName $_lastName',
          'email': activeFireUser.email,
          'isEmailVerified': activeFireUser.isEmailVerified,
          'photoUrl': activeFireUser.photoUrl,
          'school': firestore.collection('schools').document('${_school.id}'),
          'classroomName': _classroom.name,
          'level': _level,
          'pathway': _pathway,
          'speciality': _speciality
        },
        merge: false,
      );
      // setState(() => _isLoading = false);
      // bloc.activeUserStream.listen((user) => print(user.displayName));
    }
  }
  
  // Valide le formulaire et le sauvegarde
  // Renvoie un booléen témoignant de l'état de validation
  // (Executée par _submit(), qui essaie d'envoyer le formulaire)
  bool _validateAndSave() {
    setState(() {
      _autovalidate = true;
      _errorMessage = '';
    });
    if (_formKey.currentState.validate()) {
      // Sauvegarde les champs du formulaire dans nos variables
      _formKey.currentState.save();
      // Création d'une variable témoignant l'existence d'un étudiant
      // par rapport aux informations qu'il a renseignées
      bool studentExists = false;

      // Utilisation du try pour pallier le cas où le singleWhere
      // renvoie une erreur à cause de l'existence multiple d'un étudiant dans la db
      try {
        // Teste si dans la liste d'étudiant de la classe sélectionnée
        // un étudiant avec ce nom et ce prénom existe
        // Assigne à studentExists la valeur booléenne de ce test
        studentExists = (_classroom.students.singleWhere(
          (student) {
            if (student.firstName == _firstName && student.lastName == _lastName) {
              setState(() => _speciality = student.speciality);
              return true;
            }
            return false;
          },
          orElse: () => null,
        ) != null);
      } 
      // Affiche un message dans le cas de l'existence multiple d'un étudiant
      catch (error) {
        setState(() {
          _errorMessage = 'Plusieurs élèves portent ce nom dans la ${_classroom.name} \n Merci de vous adresser à votre établissement';
        });
        _cancelData();
        return false;
      }
      // Informe que le formulaire est valide
      if (studentExists) {
        return true;
      }
      // Informe que le formulaire est invalide
      // Supprime les données stockées dans les variables
      // Retourne un message d'erreur
      else {
        setState(() {
          _errorMessage =
              'Aucun élève à votre nom n\'a été trouvé dans la ${_classroom.name}';
        });
        _cancelData();
        return false;
      }
    }
    // Informe immédiatement que le formulaire est invalide
    // dans le cas ou les champs du formulaire ne respectent pas
    // leurs propres règles de validation
    return false;
  }

  // Retourne une Row avec les champs nom et prénom
  // (Appelée par _showBody())
  Widget _nameFields() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: _firstNameField(),
        ),
        SizedBox(width: _spacing),
        Expanded(
          child: _lastNameField(),
        ),
      ],
    );
  }

  // Retourne le champ de saisie du prénom
  // (Appelée par _nameFields())
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

  // Retourne le champ de saisie du nom
  // (Appelée par _nameFields())
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

  // Retourne le sélecteur d'école
  // (Exéxutée par _showBody())
  Widget _schoolField(List<School> schools) {
    return DropdownButtonFormField(
      // Convertit la liste de School renvoyées suite à la requête Firestore
      // en une liste de DropdownMenuItem affichant le nom de l'école
      // et renvoyant son index dans la liste renseignée
      items: schools.map((School school) {
        return DropdownMenuItem<int>(
          value: schools.indexOf(school),
          child: Text('$school'),
        );
      }).toList(),
      // A chaque sélection d'école
      onChanged: (value) {
        setState(() {
          // Réinitialise l'index de la classe sélectionnée
          _classroomIndex = null;
          // Assigne à la variable _schoolIndex 
          // la valeur d'index de l'item sélectionné
          _schoolIndex = value;
        });
      },
      value: _schoolIndex,
      validator: validateSchool,
      onSaved: (value) => _school = schools[value],
      hint: Text('Établissement'),
      decoration: InputDecoration(
        // Affiche "Etablissement"
        // dans le cas où aucune école n'a été sélectionnée
        labelText: (_schoolIndex != null) ? 'Établissement' : '',
        filled: true,
      ),
    );
  }
  // Retourne le sélecteur de classe
  // (Appelée par _showBody())
  Widget _classroomField(List<School> schools) {
    // Crée une liste regroupant les classes de l'école sélectionnée
    // Si aucune école n'est sélectionnée, la liste est vide
    List<Classroom> classrooms = (_schoolIndex != null)
      ? schools[_schoolIndex].classrooms
      : [];
      print(classrooms);

    return DropdownButtonFormField(
      // SI CLASSROOMS N'EST PAS VIDE
      // Convertit la liste classroom en une liste de DropdownMenuItem
      // affichant le nom de la classe
      // et renvoyant son index dans la liste classroom
      // SI CLASSROOMS EST VIDE
      // Renvoie null
      items: (classrooms.length != 0)
          ? classrooms.map((classroom) {
              return DropdownMenuItem(
                value: classrooms.indexOf(classroom),
                child: Text('$classroom'),
              );
            }).toList()
          : null,
      // A chaque sélection de classe
      onChanged: (value) {
        print(classrooms[value]);
        setState(() {
          // Assigne à la variable _schoolIndex 
          _classroomIndex = value;
        });
      },
      value: _classroomIndex,
      validator: validateClassroom,
      onSaved: (value) {
        _classroom = classrooms[value];
        _level = _classroom.level;
        _pathway = _classroom.pathway;
      },
      hint: Text('Classe'),
      decoration: InputDecoration(
        // Affiche "Classe"
        // dans le cas où aucune classe n'a été sélectionnée
        labelText: (_classroomIndex != null) ? 'Classe' : '',
        filled: true,
      ),
    );
  }

  // Retourne le bouton de validation
  // (Appelée par _showBody())
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Quand appuyé, exécute la fonction _submit()
      onPressed: _submit,
    );
  }

  // Retourne le bouton d'annulation
  // (Appelée par _showBody())
  Widget _cancelButton() {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Quand appuyé, éxécute la fonction _cancel()
      onPressed: _cancel,
    );
  }

  // Permet à l'utilisateur d'annuler son inscription
  // et de retourner à la Hello Page
  // /!\ Supprime le compte Firebase de l'utilisateur
  // (Appelée par _cancelButton())
  void _cancel() {
    final AuthBase auth = AuthProvider.of(context).auth;
    showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text('Annuler l\'inscription'),
            content: Text('Souhaitez-vous réellement annuler la procédure d\'inscription ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(context2).pop(),
              ),
              FlatButton(
                textColor: Colors.red[400],
                child: Text('Continuer'),
                onPressed: () async {
                  FirebaseUser user = await auth.currentUser();
                  // Supprime le compte de l'utilisateur connecté
                  try {
                    await user.delete();
                    Navigator.of(context2).pop();
                  } 
                  on PlatformException {
                    Navigator.of(context2).pop();
                    print('wow');
                    showDialog(
                      context: context,
                      builder: (context3) {
                        return AlertDialog(
                          title: Text('Délai dépassé'),
                          content: Text('Vous ne pouvez pas supprimer votre compte en raison d\'un trop long délai entre votre reqûete et votre dernière connexion.\nVous allez être redirigé vers l\'écran de bienvenue.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Annuler"),
                              onPressed: () => Navigator.of(context3).pop(),
                            ),
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                auth.signOut();
                                Navigator.of(context3).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                  }
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<String> _manageProfilePic() async {
    String imageUrl = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation, animation2) {
          return ProfilePicPage();
        },
        transitionsBuilder: (context, animation, animation2, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(animation2),
              child: child,
            ),
          );
        },
      ),
    );
    return imageUrl;
  }

  // Retourne une zone de texte affichant le message d'erreur actuel
  // si il y en a un, et un Container vide sinon
  // (Appelée par _showBody())
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

  // Retourne le logo
  // (Appelée par _showBody())
  Widget _showLogo() {
    return Column(
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

  // Réinitialise tous les champs d'info de l'utilisateur
  // (Appelée par _validateAndSave())
  void _cancelData() {
    setState(() {
      _firstName = '';
      _lastName = '';
      _school = null;
      _classroom = null;
      _level = '';
      _pathway = '';
      _speciality = '';
    });
  }
}
