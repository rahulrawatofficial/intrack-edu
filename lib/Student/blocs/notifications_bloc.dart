import 'package:intrack/Student/models/notifications_model.dart';
import 'package:intrack/Student/resources/Notifications/notifications_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class NotificationsBloc {
  final _repository = NotificationsRepository();
  final _notificationsFetcher = PublishSubject<NotificationsModel>();

  Observable<NotificationsModel> get allNotifications =>
      _notificationsFetcher.stream;

  fetchAllNotifications(
      BuildContext context, String userToken, String studentId) async {
    NotificationsModel notificationsModel =
        await _repository.fetchAllNotifications(context, userToken, studentId);
    _notificationsFetcher.sink.add(notificationsModel);
  }

  dispose() {
    _notificationsFetcher.close();
  }
}

final notificationsBloc = NotificationsBloc();
