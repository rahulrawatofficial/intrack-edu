// To parse this JSON data, do
//
//     final resultModel = resultModelFromJson(jsonString);

import 'dart:convert';

ResultModel resultModelFromJson(String str) =>
    ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  bool success;
  String message;
  List<Datum> data;

  ResultModel({
    this.success,
    this.message,
    this.data,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => new ResultModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  List<Performance> performance;
  double percentage;
  double totalPercentage;

  Datum({
    this.id,
    this.performance,
    this.percentage,
    this.totalPercentage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        performance: new List<Performance>.from(
            json["performance"].map((x) => Performance.fromJson(x))),
        percentage: json["percentage"].toDouble(),
        totalPercentage: json["totalPercentage"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "performance":
            new List<dynamic>.from(performance.map((x) => x.toJson())),
        "percentage": percentage,
        "totalPercentage": totalPercentage,
      };
}

class Performance {
  String id;
  String studentId;
  int marksObtained;
  int maximumMarks;
  String grade;
  String subject;

  Performance({
    this.id,
    this.studentId,
    this.marksObtained,
    this.maximumMarks,
    this.grade,
    this.subject,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => new Performance(
        id: json["_id"],
        studentId: json["studentId"],
        marksObtained: json["marksObtained"],
        maximumMarks: json["maximumMarks"],
        grade: json["grade"],
        subject: json["subject"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "studentId": studentId,
        "marksObtained": marksObtained,
        "maximumMarks": maximumMarks,
        "grade": grade,
        "subject": subject,
      };
}
