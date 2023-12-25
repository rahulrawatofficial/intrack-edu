import 'package:intrack/Teacher/models/previous_attendance_model.dart';
import 'package:intrack/Teacher/resources/Attendance/get_attendance_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class PreviousAttendanceBloc {
  final _repository = PreviousAttendanceRepository();
  final _previousAttendanceFetcher = PublishSubject<PreviousAttendanceModel>();

  Observable<PreviousAttendanceModel> get allPreviousAttendance =>
      _previousAttendanceFetcher.stream;

  fetchAllAttendance(String userToken, String sectionId, String date,
      BuildContext context) async {
    PreviousAttendanceModel attendanceModel = await _repository
        .fetchAllPreviousAttendance(userToken, sectionId, date, context);
    _previousAttendanceFetcher.sink.add(attendanceModel);
  }

  dispose() {
    _previousAttendanceFetcher.close();
  }
}

final previousAttendanceBloc = PreviousAttendanceBloc();
