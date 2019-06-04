import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/models/school_model.dart';

// TODO : Ajouter l'attribution d'une School() et d'une Classroom()

class StudentUser {

  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final bool isEmailVerified;
  final String photoUrl;
  // School school;
  // Classroom classroom;
  final String schoolName;
  final String classroomName;
  final Level level;
  final Pathway pathway;
  final Speciality speciality;
  final FirebaseUser firebaseUser;

  // StudentUser({
  //   @required this.id,
  //   @required this.firstName,
  //   @required this.lastName,
  //   @required this.email,
  //   @required this.photoUrl,
  //   @required this.school,
  //   @required this.classroom,
  //   @required this.speciality,
  //   @required this.firebaseUser
  // });

  // Construction d'un objet StudentUser() via un document Firestore
  StudentUser.fromFirestoreDocument(DocumentSnapshot doc, FirebaseUser activeFirebaseUser)
    : id = doc.documentID,
      firstName = doc.data['firstName'],
      lastName = doc.data['lastName'],
      displayName = doc.data['displayName'],
      email = doc.data['email'],
      isEmailVerified = doc.data['isEmailVerified'],
      photoUrl = doc.data['photoUrl'],
      // school = schools.singleWhere((school) => school.name == doc.data['schoolName']),
      schoolName = doc.data['schoolName'],
      // classroom = schools.singleWhere((school) => school.name == doc.data['schoolName'])
      //   .classrooms.singleWhere((classroom) => classroom.name == doc.data['classroomName']),
      classroomName = doc.data['classroomName'],
      level = _getLevel(doc.data['level']),
      pathway = _getPathway(doc.data['pathway']),
      speciality = _getSpeciality(doc.data['speciality']),
      firebaseUser = activeFirebaseUser;

  // Getter qui renvoie, à partir des prénom et nom d'un étudiant, son nom complet
  String get fullName => '$firstName $lastName';

  static Level _getLevel(level) {
    switch (level) {
      case 'seconde':
        return Level.SECONDE;
      case 'premiere':
        return Level.PREMIERE;
      case 'terminale':
        return Level.TERMINALE;
      default:
        return Level.UNKNOWN;
    }
  }

  // Retourne la filière de l'élève
  // sous forme d'une valeur de l'enum Pathway
  // (Appelée par StudentUser.fromFirestoreDocument())
  static Pathway _getPathway(pathway) {
    switch (pathway) {
      case 'S':
        return Pathway.S;
      case 'ES':
        return Pathway.ES;
      case 'L':
        return Pathway.L;
      case 'STMG':
        return Pathway.STMG;
      default:
        return Pathway.UNKNOWN;
    }
  }

  // Retourne la filière de l'élève
  // sous forme d'une valeur de l'enum Speciality
  // (Appelée par StudentUser.fromFirestoreDocument())
  static Speciality _getSpeciality(speciality) {
    switch (speciality) {
      case 'ISN':
        return Speciality.ISN;
      case 'SVT':
        return Speciality.SVT;
      default:
        return Speciality.UNKNOWN;
    }
  }

  // Le texte renvoyé lors de l'interpolation d'un StudentUser() avec un String
  String toString() {
    return '$firstName $lastName';
  }

  // Un retour plus complet pour l'identification d'erreurs
  String toStringDebug() {
    String string = '';
    string += 'id: $id';
    string += '\n';
    string += 'firstName: $firstName';
    string += '\n';
    string += 'lastName: $lastName';
    string += '\n';
    string += 'email: $email';
    string += '\n';
    string += 'photoUrl: $photoUrl';
    string += '\n';
    string += 'schoolName: $schoolName';
    string += '\n';
    string += 'classroomName: $classroomName';
    string += '\n';
    string += 'speciality: $speciality';
    return string;
  }
}