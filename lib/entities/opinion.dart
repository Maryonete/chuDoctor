import 'package:flutter/foundation.dart';

class Opinion {
  final int id;
  final String title;
  final String description;
  final DateTime date;

  Opinion({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
