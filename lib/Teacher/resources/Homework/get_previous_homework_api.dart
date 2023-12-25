import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/previous_homework_model.dart';

class GetPreviousHomeworkApi {
  Future<PreviousHomeworkModel> getPreviousHomework(String userToken,
      String sectionId, String date, BuildContext context) async {
    String path = "/v1/getHomeworkList";
    Map<String, String> params = {
      "sectionId": sectionId,
      "date": date,
    };
    print("entered" + params.toString());
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
        queryParameters: params,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return PreviousHomeworkModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "TEACHER");
    }
  }
}
