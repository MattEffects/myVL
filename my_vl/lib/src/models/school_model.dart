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
  final List<Classroom> classrooms;

  School.fromJson(Map<String, dynamic> parsedJson)
    : name = parsedJson['name'],
      classrooms = parsedJson['classrooms'];
}

class Classroom {
  final String name;
  final Level level;
  final Pathway pathway;
  final List<Student> students;

  Classroom.fromJson(Map<String, dynamic> parsedJson)
    : name = parsedJson['name'],
      level = parsedJson['level'],
      pathway = parsedJson['pathway'],
      students = parsedJson['students'];
}

class Student {
  final String firstName;
  final String secondName;
  final String lastName;

  Student.fromJson(Map<String, String> parsedJson)
    : firstName = parsedJson['firstName'],
      secondName = parsedJson['secondName'],
      lastName = parsedJson['lastName'];
}