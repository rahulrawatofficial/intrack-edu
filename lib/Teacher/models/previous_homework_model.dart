// To parse this JSON data, do
//
//     final previousHomeworkModel = previousHomeworkModelFromJson(jsonString);

import 'dart:convert';

PreviousHomeworkModel previousHomeworkModelFromJson(String str) =>
    PreviousHomeworkModel.fromJson(json.decode(str));

String previousHomeworkModelToJson(PreviousHomeworkModel data) =>
    json.encode(data.toJson());

class PreviousHomeworkModel {
  bool success;
  String message;
  List<Datum> data;

  PreviousHomeworkModel({
    this.success,
    this.message,
    this.data,
  });

  factory PreviousHomeworkModel.fromJson(Map<String, dynamic> json) =>
      new PreviousHomeworkModel(
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
  List<dynamic> studentId;
  String id;
  String sectionId;
  DateTime date;
  Homework homework;
  int v;

  Datum({
    this.studentId,
    this.id,
    this.sectionId,
    this.date,
    this.homework,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        studentId: new List<dynamic>.from(json["studentId"].map((x) => x)),
        id: json["_id"],
        sectionId: json["sectionId"],
        date: DateTime.parse(json["date"]),
        homework: Homework.fromJson(json["homework"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "studentId": new List<dynamic>.from(studentId.map((x) => x)),
        "_id": id,
        "sectionId": sectionId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "homework": homework.toJson(),
        "__v": v,
      };
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

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "subjectName": subjectName,
        "problems": problems,
        "documentUrl": documentUrl,
        "fileType": fileType,
      };
}
