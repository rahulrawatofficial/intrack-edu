import 'package:flutter/material.dart';
import 'package:intrack/Student/models/attendance_calender_model.dart';
import 'package:intrack/Student/resources/Attendance/CalenderView/attendance_calenderview_repository.dart';
import 'package:rxdart/rxdart.dart';

class AttendanceCalenderBloc {
  final _repository = AttendanceCalenderRepository();
  final _attendanceCalenderFetcher = PublishSubject<AttendanceCalenderModel>();

  Observable<AttendanceCalenderModel> get allAttendance =>
      _attendanceCalenderFetcher.stream;

  fetchAllAttendance(
    BuildContext context,
    String userToken,
    String studentId,
  ) async {
    AttendanceCalenderModel attendanceCalenderModel =
        await _repository.fetchAttendanceCalender(
      context,
      userToken,
      studentId,
    );
    _attendanceCalenderFetcher.sink.add(attendanceCalenderModel);
  }

  dispose() {
    _attendanceCalenderFetcher.close();
  }
}

final attendanceCalenderBloc = AttendanceCalenderBloc();
