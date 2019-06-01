List<String> levels = ['seconde', 'premiere', 'terminale'];
List<String> pathways = ['S', 'ES', 'L', 'STMG', 'STI2D', 'ST2S'];

enum Level {
  SECONDE,
  PREMIERE,
  TERMINALE,
  UNKNOWN,
}
enum Pathway {
  S,
  ES,
  L,
  STMG,
  UNKNOWN,
}

enum Speciality {
  ISN,
  SVT,
  UNKNOWN,
}

class School {
  final String name;
  final List<Classroom> classrooms;

  School.fromJson(parsedJson)
    : name = parsedJson['name'],
      classrooms = _getSchoolClasses(parsedJson['classes']);

  static List<Classroom> _getSchoolClasses(classroomsList) {
    List<Classroom> classrooms = [];
    classroomsList.forEach((classroom) {
      final Classroom classroomToAdd = Classroom.fromJson(classroom);
      classrooms.add(classroomToAdd);
    });
    return classrooms;
  }

  String toString() {
    return name;
  }

  String toStringDebug() {
    String getClasserooms(classrooms) {
      String message = '';
      classrooms.forEach((classroom) {
        message = message + 'La ${classroom.name} qui regroupe les élèves ${classroom.getStudentsNames()}\n';
      });
      return message.replaceRange(message.length-1, message.length, '');
    }
    return """ 
    Une école merveilleuse : $name
    Avec ${classrooms.length} classrooms :
    ${getClasserooms(classrooms)}
    Que de bonheur !!
    """;
  }
}

class Classroom {
  final String name;
  final String level;
  final String pathway;
  final List<Student> students;

  Classroom.fromJson(parsedJson)
    : name = parsedJson['name'],
      level = parsedJson['level'],
      pathway = parsedJson['pathway'],
      students = _getStudents(parsedJson['students']);

  String toString() {
    return name;
  }

  String getStudentsNames() {
    String message = '';
    students.forEach((student) {
      message = message + '${student.toString()}, ';
    });
    return message.replaceRange(message.length-2, message.length, '');
  }

  static List<Student> _getStudents(studentsList) {
    List<Student> students = [];
    studentsList.forEach((student) {
      final studentToAdd = Student.fromJson(student);
      students.add(studentToAdd);
    });
    return students;
  }

}

class Student {
  final String firstName;
  // final String secondName;
  final String lastName;
  final String speciality;

  Student.fromJson(parsedJson)
    : firstName = parsedJson['firstName'],
      // secondName = parsedJson['secondName'],
      lastName = parsedJson['lastName'],
      speciality = parsedJson['speciality'];

  String toString() {
    return '$firstName $lastName';
  }
}