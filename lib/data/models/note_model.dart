import 'package:flutter/material.dart'; 
class NoteModel {
  String? id;
  final String title;
  final String body;
  final Color color;

  NoteModel( {
    this.id,
    required this.title,
    required this.body,
    required this.color,
  });

  // factory NoteModel.fromJson(Map<String, dynamic> json) {
  //   return NoteModel(
  //     title: json['title'],
  //     body: json['body'],
  //     color: json['color'],
  //   );
  // }
}
