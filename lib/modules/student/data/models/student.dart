import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/auth/data/models/student_creation_form.dart';
import 'package:math_corn/modules/main/data/models/grade.dart';

class StudentProfile extends Equatable {
  final String uid;
  final String email;
  final String studentPhone;
  final String parentPhone;
  final String gradeId; // تم تغييرها من int grade إلى String gradeId
  final String name;
  final List<String>? onGoing;
  final List<String>? cart;

  StudentProfile(
    this.uid, {
    required this.email,
    required this.studentPhone,
    required this.parentPhone,
    required this.gradeId,
    required this.name,
    this.onGoing,
    this.cart,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      json['uid'],
      email: json['email'],
      studentPhone: json['studentPhone'],
      parentPhone: json['parentPhone'],
      gradeId: json['gradeId'] ?? "grade_${json['grade']}",
      // تم تغييرها من grade إلى gradeId
      name: json['name'],
      onGoing: json['onGoing'] != null
          ? List<String>.from(json['onGoing'])
          : null,
      cart: json['cart'] != null ? List<String>.from(json['cart']) : null,
    );
  }

  factory StudentProfile.fromCreationForm(
    String uid,
    StudentCreationForm creationForm,
  ) {
    return StudentProfile(
      uid,
      email: creationForm.email,
      studentPhone: creationForm.studentPhone,
      parentPhone: creationForm.parentPhone,
      gradeId: creationForm.gradeId,
      // تم تغييرها من grade إلى gradeId
      name: creationForm.name,
      cart: [],
      onGoing: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'studentPhone': studentPhone,
    'parentPhone': parentPhone,
    'gradeId': gradeId, // تم تغييرها من grade إلى gradeId
    'name': name,
    'onGoing': onGoing,
    'cart': cart,

    'uid': uid,
  };

  StudentProfile copyWith({
    String? email,
    String? studentPhone,
    String? parentPhone,
    String? gradeId,
    String? name,
    List<String>? onGoing,
    List<String>? cart,
    List<String>? savedVideos,
    List<String>? savedFiles,
  }) {
    return StudentProfile(
      uid,
      email: email ?? this.email,
      studentPhone: studentPhone ?? this.studentPhone,
      parentPhone: parentPhone ?? this.parentPhone,
      gradeId: gradeId ?? this.gradeId,
      name: name ?? this.name,
      onGoing: onGoing ?? this.onGoing,
      cart: cart ?? this.cart,
    );
  }

  Grade? get grade => GradeData.getGradeById(gradeId);

  String get gradeName => GradeData.getGradeNameById(gradeId) ?? 'غير محدد';

  bool isEnrolled(courseId) {
    return onGoing?.contains(courseId) ?? false;
  }

  bool isInCart(courseId) {
    return cart?.contains(courseId) ?? false;
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    studentPhone,
    parentPhone,
    gradeId,
    name,
    onGoing,
    cart,
  ];
}
