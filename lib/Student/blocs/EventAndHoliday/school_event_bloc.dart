import 'package:flutter/material.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_event_model.dart';
import 'package:intrack/Student/models/get_notifications_model.dart';
import 'package:intrack/Student/resources/EventAndHolidays/Events/school_event_repository.dart';
import 'package:intrack/Student/resources/Notifications/get_notifications_repository.dart';
import 'package:rxdart/rxdart.dart';

class SchoolEventBloc {
  final _repository = SchoolEventRepository();
  final _schoolEventFetcher = PublishSubject<SchoolEventModel>();

  Observable<SchoolEventModel> get allSchoolEvent => _schoolEventFetcher.stream;

  fetchAllSchoolEvent(BuildContext context, String userToken) async {
    SchoolEventModel schoolEventModel =
        await _repository.fetchAllSchoolEvent(userToken, context);
    _schoolEventFetcher.sink.add(schoolEventModel);
  }

  dispose() {
    _schoolEventFetcher.close();
  }
}

final schoolEventBloc = SchoolEventBloc();
