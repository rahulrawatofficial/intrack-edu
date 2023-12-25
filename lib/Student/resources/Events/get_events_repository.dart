import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/event_list_model.dart';
import 'package:intrack/Student/resources/Events/get_events_api.dart';

class EventsRepository {
  final moviesApiProvider = GetEventsApi();

  Future<EventListModel> fetchAllEvents(
          BuildContext context, String userToken, String studentId) =>
      moviesApiProvider.getEvents(context, userToken, studentId);
}
