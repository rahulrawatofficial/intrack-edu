import 'dart:async';
// import 'package:intrack/Student/models/get_homework_model.dart';
// import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/resources/Notifications/notifications_api.dart';
import 'package:intrack/Student/models/notifications_model.dart';

class NotificationsRepository {
  final notificationsApiProvider = NotificationsApi();

  Future<NotificationsModel> fetchAllNotifications(
          BuildContext context, String userToken, String studentId) =>
      notificationsApiProvider.getNotifications(context, userToken, studentId);
}
