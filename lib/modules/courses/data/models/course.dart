import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';

class Course extends Equatable {
  final String name;
  final String? image;
  final double oldPrice;
  final double? newPrice;
  final String description;
  final int subscribers;
  final List<Lecture> lectures;
  final String id;

  const Course({
    required this.name,
    this.image,
    required this.oldPrice,
    this.newPrice,
    required this.description,
    required this.subscribers,
    required this.lectures,
    required this.id,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      image: json['image'],
      oldPrice: json['oldPrice'],
      newPrice: json['newPrice'],
      description: json['description'],
      subscribers: json['subscribers'],
      lectures: (json['lectures'] as List)
          .map((e) => Lecture.fromJson(e))
          .toList(),
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'description': description,
      'subscribers': subscribers,
      'lectures': lectures.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }

  @override
  List<Object?> get props => [
    name,
    image,
    oldPrice,
    newPrice,
    description,
    subscribers,
    lectures,
    id,
  ];
}
