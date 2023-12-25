import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';

var path = "/v1/getParticularLeave";
Future<dynamic> getParticularLeave(
  BuildContext context,
  String userToken,
  String leaveId,
) async {
  Map<String, dynamic> params = {
    "leaveId": leaveId,
  };
  var url = Uri(
    scheme: "https",
    host: "api-dashboard.intrack.in",
    // port: 8001,
    path: path,
    queryParameters: params,
  );
  print(url);
  var response = await http.get(
    url,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "authorization": "Bearer " + userToken
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

    showDialogSingleButton(
      context,
      status,
      message,
      "ok",
    );
  } else
    data = json.decode(response.body);
  return data;
}
