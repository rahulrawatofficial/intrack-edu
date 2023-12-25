import 'package:flutter/material.dart';
import 'package:intrack/Student/models/event_list_model.dart';
import 'package:intrack/Student/resources/Events/get_events_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = EventsRepository();
  final _eventsFetcher = PublishSubject<EventListModel>();

  Observable<EventListModel> get allEvents => _eventsFetcher.stream;

  fetchAllEvents(
      BuildContext context, String userToken, String studentId) async {
    EventListModel eventsModel =
        await _repository.fetchAllEvents(context, userToken, studentId);
    _eventsFetcher.sink.add(eventsModel);
  }

  dispose() {
    _eventsFetcher.close();
  }
}

final eventsBloc = EventsBloc();
