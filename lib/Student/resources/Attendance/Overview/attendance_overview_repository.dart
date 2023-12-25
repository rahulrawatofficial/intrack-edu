import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/attendance_overview_model.dart';
import 'package:intrack/Student/resources/Attendance/Overview/attendance_overview_api.dart';

class AttendanceOverviewRepository {
  final attendanceOverviewProvider = AttendanceOverviewApi();

  Future<AttendanceOverviewModel> fetchAttendanceOverview(
    BuildContext context,
    String userToken,
    String studentId,
    String selectedDate1,
    String selectedDate2,
  ) =>
      attendanceOverviewProvider.getAttendanceOverview(
          context, userToken, studentId, selectedDate1, selectedDate2);
}
