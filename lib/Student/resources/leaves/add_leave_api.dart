import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/add_leave_model.dart';

Future<dynamic> addLeave(
  BuildContext context,
  String userToken,
  String title,
  String description,
  List leaveDates,
  String studentId,
  String classId,
  String sectionId,
) async {
  List<LeaveDate> leaveList = [];
  for (var i = 0; i < leaveDates.length; i++) {
    leaveList.add(LeaveDate(dateOfLeave: leaveDates[i]));
  }

  AddLeaveModel body = AddLeaveModel(
    leaveDates: leaveList,
    leaveTitle: title,
    leaveDescription: description,
    studentId: studentId,
    classId: classId,
    sectionId: sectionId,
  );
  var url = Uri(
    scheme: "https",
    host: "api-dashboard.intrack.in",
    // port: 8001,
    path: "/v1/createLeave",
  );
  print(url);
  var response = await http.post(
    url,
    body: json.encode(body),
    headers: {
      "Accept": "application/json",
      "authorization": "Bearer " + userToken,
      "Content-Type": "application/json"
    },
  );

  print(response.statusCode);
  // print(response.body);

  var data;
  var status;
  var message;
  if (response.statusCode == 401) {
    logOut();
    return ShowError().tokenExpired(
        context, "Error", "Session Expired", "Login", userToken, "STUDENT");
  }
  if (response.statusCode != 200) {
    status = "Failed";
    message = "Failed to Fetch the list";
    print(response.body);
    print(json.encode(body) + "heelllloo");
    showDialogSingleButton(
      context,
      status,
      message,
      "ok",
    );
  } else
    print(json.encode(body) + "heelllloo");
  return data;
}
