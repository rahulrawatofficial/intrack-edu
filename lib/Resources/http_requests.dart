import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'dart:io';

import 'package:intrack/Resources/error_handling.dart';

class ApiBase {
  String scheme = "https";
  // String host = "13.232.97.197";
  String host = "api-dashboard.intrack.in"; //test server
  // String host = "192.168.43.100";// local
  // String host = "192.168.43.33";

  int port;
  ErrorHandling _errorHandling = ErrorHandling();

  List serviceList = List();

  addServie() {
    serviceList.add("/v1/studentViewTimeTable");
    serviceList.add("/v1/getStudentCourses");
    serviceList.add("/v1/getParticularCourseDetail");
    serviceList.add("/v1/getLiveClassesesList");
    serviceList.add("/v1/getCourseesList");
    serviceList.add("/v1/createLiveClasses");
    serviceList.add("/v1/updateLiveClasses");
    serviceList.add("/v1/createCourseAttendance");
    serviceList.add("/v1/updateCourseAttendance");
    serviceList.add("/v1/getStudentCourseAttendance");
  }

  Map<String, String> authHeader = {
    "Content-Type": "application/x-www-form-urlencoded",
  };
  Map<String, String> authHeaderPost = {
    "Content-Type": "application/json",
  };

  Future<dynamic> get(BuildContext context, String serviceName,
      Map<String, dynamic> params, String userTokenNew) async {
    addServie();
    var responseJson;
    print("$serviceName/$params");
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "Bearer $userTokenNew");
      print(authHeader);
    }

    try {
      final response = await http.get(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          queryParameters: params != null ? params : null,
        ),
        headers: authHeader,
      );
      responseJson = _returnResponse(context, response, userTokenNew);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
    }
    return responseJson;
  }

  Future<dynamic> post(BuildContext context, String serviceName, var params,
      dynamic body, String userTokenNew) async {
    addServie();
    var responseJson;
    if (serviceList.contains(serviceName)) {
      authHeaderPost.putIfAbsent("Authorization", () => "Bearer $userTokenNew");
      print(authHeaderPost);
    }
    try {
      final response = await http.post(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          // queryParameters: params != null ? params : null,
        ),
        body: json.encode(body),
        headers: authHeaderPost,
      );
      print("###${json.encode(body)} $serviceName###");
      print(response.statusCode);
      print(response.body);
      responseJson = _returnResponse(context, response, userTokenNew);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
      return responseJson;
    }
    return responseJson;
  }

  Future<dynamic> put(BuildContext context, String serviceName, Map params,
      dynamic body, String userTokenNew) async {
    addServie();
    print(body);
    var responseJson;
    print("###${json.encode(body)} $serviceName###");
    if (serviceList.contains(serviceName)) {
      authHeaderPost.putIfAbsent("Authorization", () => "Bearer $userTokenNew");
    }
    try {
      final response = await http.put(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          // queryParameters: params != null ? params : null,
        ),
        body: json.encode(body),
        headers: authHeaderPost,
      );
      print(response.statusCode);
      print(response.body);
      responseJson = _returnResponse(context, response, userTokenNew);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
      return responseJson;
    }
    return responseJson;
  }

  Future<dynamic> delete(BuildContext context, String serviceName, Map params,
      String userToken) async {
    var responseJson;
    if (serviceList.contains(serviceName)) {
      authHeader.putIfAbsent("Authorization", () => "Bearer $userToken");
    }
    try {
      final response = await http.delete(
        Uri(
          scheme: scheme,
          host: host,
          port: port,
          path: serviceName,
          queryParameters: params != null ? params : null,
        ),
        headers: authHeader,
      );
      responseJson = _returnResponse(context, response, userToken);
    } on SocketException {
      _errorHandling.showErrorDailog(
          context, "Network Error", "Check your internet connection");
    }
    return responseJson;
  }

  http.Response _returnResponse(
      BuildContext context, http.Response response, String userToken) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        var d = json.decode(responseJson);
        if (d["responseMessage"] == "error")
          _errorHandling.showErrorDailog(context, "Error", d["errorMessage"]);
        print(responseJson);
        return response;
      case 400:
        _errorHandling.showErrorDailog(
            context, "Bad Request", "Data not found");
        return response;
      case 401:
        logOut();
        ShowError().tokenExpired(
            context, "Error", "Token Expired", "Ok", userToken, "STUDENT");
        return null;
      case 403:
        _errorHandling.showErrorDailog(
            context, "Unauthorized", "You are Unauthorized");
        return response;
      case 500:
      default:
        _errorHandling.showErrorDailog(
            context, "Connection", "No Connection found");
        return response;
    }
  }
}
