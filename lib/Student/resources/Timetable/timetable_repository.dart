import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/timetable_model.dart';
import 'package:intrack/Student/resources/Timetable/timetable_api.dart';

class TimeTableRepository {
  final timeTableApi = TimeTableApi();

  Future<TimeTableModel> fetchTimeTable(
          BuildContext context, String userToken, String studentId) =>
      timeTableApi.getTimeTable(context, userToken, studentId);
}
