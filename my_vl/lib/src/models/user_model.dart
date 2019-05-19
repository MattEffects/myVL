import 'school_model.dart';

class UserModel {

  final int id;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final School school;
  final Classroom classroom;

  UserModel.fromJson(Map<String, dynamic> parsedJson)
    : id = parsedJson['id'],
      firstName = parsedJson['firstName'],
      lastName = parsedJson['lastName'],
      photoUrl = parsedJson['photoUrl'],
      school = parsedJson[''],
      classroom = parsedJson['classroom'];

}