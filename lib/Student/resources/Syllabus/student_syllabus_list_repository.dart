import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/student_syllabus_list_model.dart';
import 'package:intrack/Student/resources/Syllabus/student_syllabus_list_api.dart';

class GetStudentSyllabusRepository {
  final getStudentSyllabusApiProvider = GetStudentSyllabusApi();

  Future<StudentSyllabusListModel> fetchAllStudentSyllabusList(
          String userToken, String sectionId, BuildContext context) =>
      getStudentSyllabusApiProvider.getStudentSyllabusList(
          userToken, sectionId, context);
}
