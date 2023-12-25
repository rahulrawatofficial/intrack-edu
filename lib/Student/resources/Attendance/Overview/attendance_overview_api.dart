import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:convert';

import 'package:intrack/Student/models/attendance_overview_model.dart';

class AttendanceOverviewApi {
  Future<AttendanceOverviewModel> getAttendanceOverview(
      BuildContext context,
      String userToken,
      String studentId,
      String selectedDate1,
      String selectedDate2) async {
    var path = "/v1/studentAttendanceOverview";
    var params = {
      "startDate": selectedDate1.toString().substring(0, 10),
      "endDate": selectedDate2.toString().substring(0, 10),
      "studentId": studentId,
    };

    http.Response response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
        queryParameters: params,
      ),
      headers: {
        "authorization": "Bearer " + userToken,
      },
    );
    print(
        "date1: ${selectedDate1.toString().substring(0, 10)}\ndate2: ${selectedDate2.toString().substring(0, 10)}");
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AttendanceOverviewModel.fromJson(data);
    } else {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Session Expired", "Login", userToken, "STUDENT");
    }
  }
}
