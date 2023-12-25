import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/diary/get_student_diary_model.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class GetStudentDiaryApi {
  Future<GetStudentDiaryModel> getDiary(
      String userToken, BuildContext context, String studentId) async {
    String path = "/v1/getDiaryListOfStudent";
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
      return GetStudentDiaryModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "STUDENT");
    }
  }
}
