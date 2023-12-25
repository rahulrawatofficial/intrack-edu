import 'package:flutter/material.dart';

class Task {
  final DateTime date;
  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;
  final String image;

  Task({
    this.date,
    this.name,
    this.category,
    this.time,
    this.color,
    this.completed,
    this.image,
  });
}
