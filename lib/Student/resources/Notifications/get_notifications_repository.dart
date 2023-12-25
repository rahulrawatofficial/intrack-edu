import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/get_notifications_model.dart';
import 'package:intrack/Student/resources/Notifications/get_notifications_api.dart';

class NotificationsRepository {
  final moviesApiProvider = GetNotificationsApi();

  Future<NotificationsModel> fetchAllNotifications(
          BuildContext context, String userToken) =>
      moviesApiProvider.getNotifications(context, userToken);
}
