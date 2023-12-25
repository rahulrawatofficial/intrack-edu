import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_holidays_model.dart';
import 'package:intrack/Student/resources/EventAndHolidays/Holidays/school_holiday_api.dart';

class SchoolHolidayRepository {
  final schoolHolidayApiProvider = SchoolHolidayApi();

  Future<SchoolHolidayModel> fetchAllSchoolHoliday(
          String userToken, BuildContext context) =>
      schoolHolidayApiProvider.getSchoolHoliday(userToken, context);
}
