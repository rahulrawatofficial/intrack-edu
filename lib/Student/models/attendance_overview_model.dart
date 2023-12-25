// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

AttendanceOverviewModel loginResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return AttendanceOverviewModel.fromJson(jsonData);
}

class AttendanceOverviewModel {
  bool success;
  String message;
  Data data;

  AttendanceOverviewModel({
    this.success,
    this.message,
    this.data,
  });

  factory AttendanceOverviewModel.fromJson(Map<String, dynamic> json) =>
      new AttendanceOverviewModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String studentId;
  Stats stats;

  Data({
    this.studentId,
    this.stats,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        studentId: json["studentId"],
        stats: Stats.fromJson(json["stats"]),
      );
}

class Stats {
  int totalWorkingdays;
  int presentDays;
  String presentPercentage;

  Stats({
    this.totalWorkingdays,
    this.presentDays,
    this.presentPercentage,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => new Stats(
        totalWorkingdays: json["totalWorkingdays"],
        presentDays: json["presentDays"],
        presentPercentage: json["presentPercentage"],
      );
}
