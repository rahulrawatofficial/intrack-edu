import 'dart:async';
// import 'package:intrack/Teacher/models/Teacherdiary/get_teacher_diary_model.dart';
import 'package:intrack/Teacher/models/get_teacher_diary_model.dart';
import 'package:intrack/Teacher/resources/TeacherDiary/get_teacher_diary_api.dart';
import 'package:flutter/material.dart';

class GetTeacherDiaryRepository {
  final getTeacherDiaryApiProvider = GetTeacherDiaryApi();

  Future<GetTeacherDiaryModel> fetchAllDiary(
          String userToken, BuildContext context) =>
      getTeacherDiaryApiProvider.getDiary(userToken, context);
}
