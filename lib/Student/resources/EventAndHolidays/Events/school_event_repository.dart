import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_event_model.dart';
import 'package:intrack/Student/resources/EventAndHolidays/Events/school_event_api.dart';

class SchoolEventRepository {
  final schoolEventApiProvider = SchoolEventApi();

  Future<SchoolEventModel> fetchAllSchoolEvent(
          String userToken, BuildContext context) =>
      schoolEventApiProvider.getSchoolEvent(userToken, context);
}
