import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type; // "public" or "private"
  final DateTime date;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.date,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      date: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [id];
}
