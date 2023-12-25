import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/previous_homework_model.dart';
import 'package:intrack/Teacher/resources/Homework/get_previous_homework_api.dart';

class PreviousHomeworkRepository {
  final previousHomeworkApiProvider = GetPreviousHomeworkApi();

  Future<PreviousHomeworkModel> fetchAllPreviousHomework(String userToken,
          String sectionId, String date, BuildContext context) =>
      previousHomeworkApiProvider.getPreviousHomework(
          userToken, sectionId, date, context);
}
