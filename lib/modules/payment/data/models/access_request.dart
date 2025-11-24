import 'dart:io';

class AccessRequest {
  final String studentId;
  final List<String> coursesId;
  final String gradeId;
  final File attachment;
  final String studentName;
  final String? fileUrl;

  AccessRequest({
    required this.studentId,
    required this.coursesId,
    required this.gradeId,
    required this.attachment,
    required this.studentName,
    this.fileUrl,
  });

  AccessRequest updateFileUrl({required String fileUrl}) {
    return AccessRequest(
      studentId: studentId,
      coursesId: coursesId,
      gradeId: gradeId,
      attachment: attachment,
      studentName: studentName,
      fileUrl: fileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'coursesId': coursesId,
      'gradeId': gradeId,
      'studentName': studentName,
      'createdAt': DateTime.now().toString(),
      'fileUrl': fileUrl,
    };
  }
}
