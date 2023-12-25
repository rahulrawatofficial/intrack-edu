// To parse this JSON data, do
//
//     final homeworkModel = homeworkModelFromJson(jsonString);

import 'dart:convert';

HomeworkModel homeworkModelFromJson(String str) {
  final jsonData = json.decode(str);
  return HomeworkModel.fromJson(jsonData);
}

class HomeworkModel {
  bool success;
  String message;
  List<Datum> data;

  HomeworkModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) =>
      new HomeworkModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  String id;
  List<Homework> homework;

  Datum({
    this.id,
    this.homework,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        homework: new List<Homework>.from(
            json["homework"].map((x) => Homework.fromJson(x))),
      );
}

class Homework {
  String status;
  String id;
  String subjectName;
  String problems;
  String documentUrl;
  String fileType;

  Homework({
    this.status,
    this.id,
    this.subjectName,
    this.problems,
    this.documentUrl,
    this.fileType,
  });

  factory Homework.fromJson(Map<String, dynamic> json) => new Homework(
        status: json["status"],
        id: json["_id"],
        subjectName: json["subjectName"],
        problems: json["problems"],
        documentUrl: json["documentUrl"],
        fileType: json["fileType"],
      );
}
