import 'dart:async';
import 'package:intrack/Student/models/diary/get_student_diary_model.dart';
import 'package:intrack/Student/resources/Diary/get_student_diary_api.dart';
import 'package:flutter/material.dart';

class GetStudentDiaryRepository {
  final getStudentDiaryApiProvider = GetStudentDiaryApi();

  Future<GetStudentDiaryModel> fetchAllDiary(
          String userToken, BuildContext context, String studentId) =>
      getStudentDiaryApiProvider.getDiary(userToken, context, studentId);
}
