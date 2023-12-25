// To parse this JSON data, do
//
//     final resultOverallModel = resultOverallModelFromJson(jsonString);

import 'dart:convert';

ResultOverallModel resultOverallModelFromJson(String str) =>
    ResultOverallModel.fromJson(json.decode(str));

String resultOverallModelToJson(ResultOverallModel data) =>
    json.encode(data.toJson());

class ResultOverallModel {
  bool success;
  String message;
  Data data;

  ResultOverallModel({
    this.success,
    this.message,
    this.data,
  });

  factory ResultOverallModel.fromJson(Map<String, dynamic> json) =>
      new ResultOverallModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int excellent;
  int good;
  int satisfactory;
  int aboveAverage;
  int average;
  int belowAverage;
  int unsatisfactory;
  int poor;

  Data({
    this.excellent,
    this.good,
    this.satisfactory,
    this.aboveAverage,
    this.average,
    this.belowAverage,
    this.unsatisfactory,
    this.poor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        excellent: json["excellent"],
        good: json["good"],
        satisfactory: json["satisfactory"],
        aboveAverage: json["aboveAverage"],
        average: json["average"],
        belowAverage: json["belowAverage"],
        unsatisfactory: json["unsatisfactory"],
        poor: json["poor"],
      );

  Map<String, dynamic> toJson() => {
        "excellent": excellent,
        "good": good,
        "satisfactory": satisfactory,
        "aboveAverage": aboveAverage,
        "average": average,
        "belowAverage": belowAverage,
        "unsatisfactory": unsatisfactory,
        "poor": poor,
      };
}
