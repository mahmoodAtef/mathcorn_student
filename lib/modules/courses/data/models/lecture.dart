import 'package:equatable/equatable.dart';

class Lecture extends Equatable {
  final String id;
  final String name;
  final String url;
  final String contentType;
  final String? examId;
  final String? fileUrl;

  const Lecture({
    required this.id,
    required this.name,
    required this.url,
    required this.contentType,
    this.examId,
    this.fileUrl,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      name: json['name'],
      url: json['contentUrl'],
      contentType: json['contentType'],
      examId: json["examId"],
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contentUrl': url,
      'contentType': contentType,
      'examId': examId,
      'fileUrl': fileUrl,
    };
  }

  Lecture copyWith({
    String? id,
    String? name,
    String? url,
    String? contentType,
    String? examId,
    bool? isComplete,
    String? fileUrl,
  }) {
    return Lecture(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      contentType: contentType ?? this.contentType,
      examId: examId ?? this.examId,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, url, contentType];
}
