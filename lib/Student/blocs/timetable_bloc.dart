import 'package:flutter/material.dart';
import 'package:intrack/Student/models/timetable_model.dart';
import 'package:intrack/Student/resources/Timetable/timetable_repository.dart';
import 'package:rxdart/rxdart.dart';

class TimeTableBloc {
  final _repository = TimeTableRepository();
  final _timeTableFetcher = PublishSubject<TimeTableModel>();

  Observable<TimeTableModel> get allTimeTable => _timeTableFetcher.stream;

  fetchAllTimeTable(
      BuildContext context, String userToken, String studentId) async {
    TimeTableModel timeTableModel =
        await _repository.fetchTimeTable(context, userToken, studentId);
    _timeTableFetcher.sink.add(timeTableModel);
  }

  dispose() {
    _timeTableFetcher.close();
  }
}

final timeTableBloc = TimeTableBloc();
