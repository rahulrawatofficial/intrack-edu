import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_event_model.dart';

class SchoolEventApi {
  Future<SchoolEventModel> getSchoolEvent(
      String userToken, BuildContext context) async {
    String path = "/v1/getSchoolEventsList";
    //Map<String, String> params = {'start': '1'};
    print("entered");
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return SchoolEventModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "STUDENT");
    }
  }
}
