import 'package:http/http.dart' as http;
// import 'package:intrack/Functions/error_handling.dart';
// import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:convert';

// import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/notifications_model.dart';

class NotificationsApi {
  Future<NotificationsModel> getNotifications(
      BuildContext context, String userToken, String studentId) async {
    String path = "/v1/studentGetNotifications";
    // Map<String, String> params = {'start': '1'};
    print("entered");
    final response = await http.get(
      Uri(
          scheme: "https",
          host: "api-dashboard.intrack.in",
          // port: 8001,
          path: path,
          queryParameters: {
            "studentId": studentId,
          }),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return NotificationsModel.fromJson(json.decode(response.body));
    }
  }
}
