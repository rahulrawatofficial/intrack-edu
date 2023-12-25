import 'dart:async';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/resources/StudentsInfoList/students_info_list_api.dart';

class StudentsInfoListRepository {
  final studnetsInfoListApiProvider = StudentsInfoApi();

  Future<StudentsInfoModel> allStudentsInfoList(String userToken,
          BuildContext context, String classId, String sectionId) =>
      studnetsInfoListApiProvider.getStudentsInfoList(
          userToken, context, classId, sectionId);
}
