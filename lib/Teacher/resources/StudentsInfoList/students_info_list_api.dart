import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/diary/get_student_diary_model.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';

class StudentsInfoApi {
  Future<StudentsInfoModel> getStudentsInfoList(String userToken,
      BuildContext context, String classId, String sectionId) async {
    // String path = "/v1/getStudentWithClass";
    print("entered");
    print(userToken);
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: "/v1/getStudentWithClass",
        queryParameters: {
          "classId": classId,
          "sectionId": sectionId,
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
      return StudentsInfoModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", userToken, "TEACHER");
    } else {
      print(response.statusCode);
    }
  }
}
