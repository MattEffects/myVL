import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'school_model.dart';

class StudentUser {

  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final bool isEmailVerified;
  final String photoUrl;
  //final School school;
  //final Classroom classroom;
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

  StudentUser.fromDocument(DocumentSnapshot doc, FirebaseUser activeFirebaseUser)
    : id = doc.documentID,
      firstName = doc.data['firstName'],
      lastName = doc.data['lastName'],
      displayName = doc.data['displayName'],
      email = doc.data['email'],
      isEmailVerified = doc.data['isEmailVerified'],
      photoUrl = doc.data['photoUrl'],
      schoolName = doc.data['schoolName'],
      classroomName = doc.data['classroomName'],
      level = _getLevel(doc.data['level']),
      pathway = _getPathway(doc.data['pathway']),
      speciality = _getSpeciality(doc.data['speciality']),
      firebaseUser = activeFirebaseUser;

  static Level _getLevel(level) {
    switch (level) {
      case 'seconde':
        return Level.SECONDE;
        break;
      case 'premiere':
        return Level.PREMIERE;
        break;
      case 'terminale':
        return Level.TERMINALE;
        break;
      default:
        return Level.UNKNOWN;
        break;
    }
  }

  static Pathway _getPathway(pathway) {
    switch (pathway) {
      case 'S':
        return Pathway.S;
        break;
      case 'ES':
        return Pathway.ES;
        break;
      case 'L':
        return Pathway.L;
        break;
      case 'STMG':
        return Pathway.STMG;
        break;
      default:
        return Pathway.UNKNOWN;
        break;
    }
  }

  static Speciality _getSpeciality(speciality) {
    switch (speciality) {
      case 'ISN':
        return Speciality.ISN;
        break;
      case 'SVT':
        return Speciality.SVT;
        break;
      default:
        return Speciality.UNKNOWN;
        break;
    }
  }

  String get fullName => '$firstName $lastName';
  String toString() {
    return '$firstName $lastName';
  }

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