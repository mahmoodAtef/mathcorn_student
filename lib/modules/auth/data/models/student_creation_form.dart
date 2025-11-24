import 'package:equatable/equatable.dart';

class StudentCreationForm extends Equatable {
  final String email;
  final String password;
  final String name;
  final String gradeId;
  final String studentPhone;
  final String parentPhone;

  StudentCreationForm({
    required this.email,
    required this.password,
    required this.name,
    required this.gradeId,
    required this.studentPhone,
    required this.parentPhone,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    name,
    gradeId,
    studentPhone,
    parentPhone,
  ];
}
