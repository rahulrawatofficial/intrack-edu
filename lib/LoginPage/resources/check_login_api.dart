import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/LoginPage/models/login_response_model.dart';
import 'package:intrack/Functions/login_logout/savecurrentlogin.dart';
import 'dart:convert';

import 'package:intrack/main.dart';

class CheckLoginApi {
  String email;
  String password;
  String role;
  String fcmToken;
  var data;

  bool isNumeric(String str) {
    try {
      var value = double.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }

  //GET STUDENTS LIST
  Future getStudents(
      BuildContext context, String authToken, String parentId) async {
    final response = await http.get(
        Uri.encodeFull(
            "https://api-dashboard.intrack.in/v1/parentStudentsList"),
        headers: {
          "authorization": "Bearer " + authToken,
        });
    print(response.statusCode);
    print(response.body);

    var data1 = json.decode(response.body);
    print("data ${data["message"]}");
    if (response.statusCode == 200) {
      print(data1);
      print("***SUCCESS*****");
      if (data1['data']['students'].length > 0) {
        var userName = data1['data']['students'][0]['name'];
        var userRole = "PARENT";
        var userToken = authToken;
        var userId = data1['data']['students'][0]['_id'];
        var classId = data1['data']['students'][0]['classId'];
        var sectionId = data1['data']['students'][0]['sectionId'];
        var studentPic = data1['data']['students'][0]['profilePicUrl'];
        int mPin = data["data"]["pinExist"] ? data["data"]["mPin"] : null;
        bool pinExist = data["data"]["pinExist"];
        saveCurrentLogin(userName, email, userRole, userToken, userId, parentId,
                classId, sectionId, studentPic, mPin, pinExist)
            .then((val) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
            ModalRoute.withName("Dashboard"),
          );
        });
      } else {
        showDialogSingleButton(
            context, "Error", "No student found for this parent", "Ok");
      }
    } else {
      String message = data1["message"];
      showDialogSingleButton(context, "Error", message, "Ok");
    }
  }

  //Check Login
  Future<void> checkLogin(BuildContext context, String url) async {
    Map<String, String> studentBody = {
      "email": email,
      "password": password,
      "role": role,
      "fcmToken": fcmToken,
    };
    Map<String, String> fatherCellBody = {
      "fatherCellNo": email,
      "password": password,
      "role": role,
      "fcmToken": fcmToken,
    };
    Map<String, String> teacherBody = {
      "email": email,
      "password": password,
      "role": role,
      "fcmToken": fcmToken,
    };
    Map<String, String> teacherCellBody = {
      "mobileNo": email,
      "password": password,
      "role": role,
      "fcmToken": fcmToken,
    };

    final response = await http.post(
      Uri.encodeFull(url),
      body: role == "PARENT" && isNumeric(email) == false
          ? studentBody
          : role == "PARENT" && isNumeric(email)
              ? fatherCellBody
              : role == "TEACHER" && isNumeric(email) == false
                  ? teacherBody
                  : teacherCellBody,
    );
    print(response.statusCode);
    print(response.body);

    data = json.decode(response.body);
    print("data ${data["message"]}");
    if (response.statusCode == 200) {
      print("***SUCCESS*** $fcmToken");
      LoginResponseModel student = new LoginResponseModel.fromJson(data);
      if (student.data.role == "PARENT") {
        getStudents(context, student.data.token, student.data.id).then((val) {
          print("#####$val######");
        });
      } else {
        var userName = student.data.name;
        var userRole = student.data.role;
        var userToken = student.data.token;
        var userId = student.data.id;
        var profilePic = student.data.profilePicUrl;
        saveCurrentLogin(userName, email, userRole, userToken, userId, "", "",
                "", profilePic, null, null)
            .then((onValue) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
            ModalRoute.withName("DashBoard"),
          );
        });
      }
    } else {
      String message = data["message"];
      showDialogSingleButton(context, "Error", message, "Ok");
    }
  }
}
