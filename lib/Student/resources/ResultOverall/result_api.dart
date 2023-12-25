import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/resultOverall_model.dart';
import 'dart:convert';

import 'package:intrack/Student/models/result_model.dart';

class ResultOverallApi {
  Future<ResultOverallModel> getResultOverall(BuildContext context,
      String userToken, String studentId, String sectionId) async {
    String path = "/v1/studentCheckAvergae";
    print("entered");
    var params = {
      "examType": "sa1",
      "studentId": studentId,
      "sectionId": sectionId,
    };
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
      return ResultOverallModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "STUDENT");
    }
  }
}
