import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/previous_attendance_model.dart';
import 'package:intrack/Teacher/resources/Attendance/get_attendance_api.dart';

class PreviousAttendanceRepository {
  final previousAttendanceApiProvider = GetPreviousAttendanceApi();

  Future<PreviousAttendanceModel> fetchAllPreviousAttendance(String userToken,
          String sectionId, String date, BuildContext context) =>
      previousAttendanceApiProvider.getPreviousAttendance(
          userToken, sectionId, date, context);
}
