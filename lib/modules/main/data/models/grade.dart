class Grade {
  final String id;
  final String name;

  const Grade({required this.id, required this.name});

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Grade && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'Grade(id: $id, name: $name)';
}

class GradeData {
  static const List<Grade> availableGrades = [
    Grade(id: 'grade_1', name: 'الصف الأول الابتدائي'),
    Grade(id: 'grade_2', name: 'الصف الثاني الابتدائي'),
    Grade(id: 'grade_3', name: 'الصف الثالث الابتدائي'),
    Grade(id: 'grade_4', name: 'الصف الرابع الابتدائي'),
    Grade(id: 'grade_5', name: 'الصف الخامس الابتدائي'),
    Grade(id: 'grade_6', name: 'الصف السادس الابتدائي'),
    Grade(id: 'grade_7', name: 'الصف الأول الإعدادي'),
    Grade(id: 'grade_8', name: 'الصف الثاني الإعدادي'),
    Grade(id: 'grade_9', name: 'الصف الثالث الإعدادي'),
    Grade(id: 'grade_10', name: 'الصف الأول الثانوي'),
    Grade(id: 'grade_11', name: 'الصف الثاني الثانوي'),
    Grade(id: 'grade_12', name: 'الصف الثالث الثانوي'),
  ];

  static Grade? getGradeById(String id) {
    try {
      return availableGrades.firstWhere((grade) => grade.id == id);
    } catch (e) {
      return null;
    }
  }

  static String? getGradeNameById(String id) {
    final grade = getGradeById(id);
    return grade?.name;
  }

  static String? getGradeIdByName(String name) {
    try {
      final grade = availableGrades.firstWhere((grade) => grade.name == name);
      return grade.id;
    } catch (e) {
      return null;
    }
  }
}
