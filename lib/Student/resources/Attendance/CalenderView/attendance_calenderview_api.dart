import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/attendance_calender_model.dart';
import 'dart:convert';

class AttendanceCalenderApi {
  Future<AttendanceCalenderModel> getAttendanceCalender(
    BuildContext context,
    String userToken,
    String studentId,
  ) async {
    var path = "/v1/studentAttendance";

    http.Response response = await http.get(
      Uri(
          scheme: "https",
          host: "api-dashboard.intrack.in",
          // port: 8001,
          path: path,
          queryParameters: {
            "studentId": studentId,
          }),
      headers: {
        "authorization": "Bearer " + userToken,
      },
    );

    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AttendanceCalenderModel.fromJson(data);
    } else {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Session Expired", "Login", userToken, "STUDENT");
    }
  }
}
