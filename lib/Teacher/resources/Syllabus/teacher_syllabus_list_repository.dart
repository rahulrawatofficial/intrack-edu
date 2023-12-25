import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/previous_homework_model.dart';
import 'package:intrack/Teacher/models/teacher_syllabus_list_model.dart';
import 'package:intrack/Teacher/resources/Homework/get_previous_homework_api.dart';
import 'package:intrack/Teacher/resources/Syllabus/teacher_syllabus_list_api.dart';

class GetTeacherSyllabusRepository {
  final getTeacherSyllabusApiProvider = GetTeacherSyllabusApi();

  Future<TeacherSyllabusListModel> fetchAllTeacherSyllabusList(
          String userToken, String sectionId, BuildContext context) =>
      getTeacherSyllabusApiProvider.getTeacherSyllabusList(
          userToken, sectionId, context);
}
