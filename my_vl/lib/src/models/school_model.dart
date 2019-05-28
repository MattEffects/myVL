List<String> levels = ['seconde', 'premiere', 'terminale'];
List<String> pathways = ['S', 'ES', 'L', 'STMG', 'STI2D', 'ST2S'];

enum Level {
  seconde,
  premiere,
  terminale,
}
enum Pathway {
  S,
  ES,
  L,
  STMG,
  STI2D,
  ST2S,
}

class School {
  final String name;
  final List<SchoolClass> classes;

  static List<SchoolClass> _getSchoolClasses(classesList) {
    List<SchoolClass> schoolClasses = [];
    classesList.forEach((schoolClass) {
      final SchoolClass schoolClassToAdd = SchoolClass.fromJson(schoolClass);
      schoolClasses.add(schoolClassToAdd);
    });
    return schoolClasses;
  }

  String toString() {
    return """ 
    Une école merveilleuse : $name
    Avec ${classes.length} classes :
    La ${classes[0].name} qui regroupe les élèves ${classes[0].getStudentsNames()}
    La ${classes[1].name} qui regroupe les élèves ${classes[1].getStudentsNames()}
    Que de bonheur !!
    """;
  }

  School.fromJson(parsedJson)
    : name = parsedJson['name'],
      classes = _getSchoolClasses(parsedJson['classes']);
}

class SchoolClass {
  final String name;
  // final Level level;
  // final Pathway pathway;
  final List<Student> students;

  String getStudentsNames() {
    return '${students[0].toString()}, ${students[1].toString()}';
  }

  static List<Student> _getStudents(studentsList) {
    List<Student> students = [];
    studentsList.forEach((student) {
      final studentToAdd = Student.fromJson(student);
      students.add(studentToAdd);
    });
    return students;
  }

  SchoolClass.fromJson(parsedJson)
    : name = parsedJson['name'],
      // level = parsedJson['level'],
      // pathway = parsedJson['pathway'],
      students = _getStudents(parsedJson['students']);


}

class Student {
  final String firstName;
  // final String secondName;
  final String lastName;

  String toString() {
    return '$firstName $lastName';
  }

  Student.fromJson(parsedJson)
    : firstName = parsedJson['firstName'],
      // secondName = parsedJson['secondName'],
      lastName = parsedJson['lastName'];
}