import 'package:flutter/material.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_holidays_model.dart';
import 'package:intrack/Student/resources/EventAndHolidays/Holidays/school_holiday_repository.dart';
import 'package:rxdart/rxdart.dart';

class SchoolHolidayBloc {
  final _repository = SchoolHolidayRepository();
  final _schoolHolidayFetcher = PublishSubject<SchoolHolidayModel>();

  Observable<SchoolHolidayModel> get allSchoolHoliday =>
      _schoolHolidayFetcher.stream;

  fetchAllSchoolHoliday(BuildContext context, String userToken) async {
    SchoolHolidayModel schoolHolidayModel =
        await _repository.fetchAllSchoolHoliday(userToken, context);
    _schoolHolidayFetcher.sink.add(schoolHolidayModel);
  }

  dispose() {
    _schoolHolidayFetcher.close();
  }
}

final schoolHolidayBloc = SchoolHolidayBloc();
