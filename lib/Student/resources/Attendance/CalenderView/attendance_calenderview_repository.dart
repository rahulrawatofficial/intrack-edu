import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/attendance_calender_model.dart';
import 'package:intrack/Student/resources/Attendance/CalenderView/attendance_calenderview_api.dart';

class AttendanceCalenderRepository {
  final attendanceCalenderProvider = AttendanceCalenderApi();

  Future<AttendanceCalenderModel> fetchAttendanceCalender(
    BuildContext context,
    String userToken,
    String studentId,
  ) =>
      attendanceCalenderProvider.getAttendanceCalender(
        context,
        userToken,
        studentId,
      );
}
