import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/leaves_list_model.dart';

class LeavesListApi {
  Future<LeavesListModel> getLeavesList(String userToken, BuildContext context,
      String sectionId, String status) async {
    // String path = "/v1/getStudentWithClass";
    print("entered");
    print(userToken);
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: "/v1/getLeavesListBySection",
        queryParameters: {
          "sectionId": sectionId,
          "status": status,
        },
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return LeavesListModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "TEACHER");
    } else {
      print(response.statusCode);
    }
  }
}
