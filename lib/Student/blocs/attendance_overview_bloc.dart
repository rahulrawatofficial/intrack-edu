import 'package:flutter/material.dart';
import 'package:intrack/Student/models/attendance_overview_model.dart';
import 'package:intrack/Student/resources/Attendance/Overview/attendance_overview_repository.dart';
import 'package:rxdart/rxdart.dart';

class AttendanceOverviewBloc {
  final _repository = AttendanceOverviewRepository();
  final _attendanceOverviewFetcher = PublishSubject<AttendanceOverviewModel>();

  Observable<AttendanceOverviewModel> get allAttendance =>
      _attendanceOverviewFetcher.stream;

  fetchAllAttendance(BuildContext context, String userToken, String studentId,
      String selectedDate1, String selectedDate2) async {
    AttendanceOverviewModel attendanceModel =
        await _repository.fetchAttendanceOverview(
            context, userToken, studentId, selectedDate1, selectedDate2);
    _attendanceOverviewFetcher.sink.add(attendanceModel);
  }

  dispose() {
    _attendanceOverviewFetcher.close();
  }
}

final attendanceOverviewBloc = AttendanceOverviewBloc();
