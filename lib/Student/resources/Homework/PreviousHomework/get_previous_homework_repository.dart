import 'dart:async';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/PreviousHomework/get_previous_homework_api.dart';
import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:flutter/material.dart';

class PreviousHomeworkRepository {
  final previousHomeworkApiProvider = GetPreviousHomeworkApi();

  Future<HomeworkModel> fetchAllHomework(String userToken, String sectionId,
          String date, BuildContext context) =>
      previousHomeworkApiProvider.getPreviousHomework(
          userToken, sectionId, date, context);
}
