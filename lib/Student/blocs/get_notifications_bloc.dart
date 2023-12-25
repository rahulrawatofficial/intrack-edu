import 'package:flutter/material.dart';
import 'package:intrack/Student/models/get_notifications_model.dart';
import 'package:intrack/Student/resources/Notifications/get_notifications_repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  final _repository = NotificationsRepository();
  final _notificationsFetcher = PublishSubject<NotificationsModel>();

  Observable<NotificationsModel> get allNotifications =>
      _notificationsFetcher.stream;

  fetchAllNotifications(BuildContext context, String userToken) async {
    NotificationsModel notificationsModel =
        await _repository.fetchAllNotifications(context, userToken);
    _notificationsFetcher.sink.add(notificationsModel);
  }

  dispose() {
    _notificationsFetcher.close();
  }
}

final notificationsBloc = NotificationsBloc();
