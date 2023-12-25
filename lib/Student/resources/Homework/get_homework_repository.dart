import 'dart:async';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:flutter/material.dart';

class HomeworkRepository {
  final homeworkApiProvider = GetHomeworkApi();

  Future<HomeworkModel> fetchAllHomework(
          String userToken, String studentId, BuildContext context) =>
      homeworkApiProvider.getHomework(userToken, studentId, context);
}
