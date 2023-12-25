import 'dart:async';
import 'package:intrack/Student/models/students_birthday_model.dart';
import 'package:intrack/Student/resources/Birthdays/student_birthdays_api.dart';
import 'package:flutter/material.dart';

class StudentsBirthdayRepository {
  final studnetsBirthdayListApiProvider = StudentsBirthdayApi();

  Future<StudentsBirthdayModel> allStudentsBirthdayList(String userToken,
          BuildContext context, String classId, String sectionId) =>
      studnetsBirthdayListApiProvider.getStudentsBirthdayList(
          userToken, context, classId, sectionId);
}
