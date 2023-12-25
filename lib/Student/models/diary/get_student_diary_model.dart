// To parse this JSON data, do
//
//     final getStudentDiaryModel = getStudentDiaryModelFromJson(jsonString);

import 'dart:convert';

GetStudentDiaryModel getStudentDiaryModelFromJson(String str) {
  final jsonData = json.decode(str);
  return GetStudentDiaryModel.fromJson(jsonData);
}

class GetStudentDiaryModel {
  bool success;
  String message;
  List<Datum> data;

  GetStudentDiaryModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetStudentDiaryModel.fromJson(Map<String, dynamic> json) =>
      new GetStudentDiaryModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  String id;
  String studentId;
  String title;
  String date;
  String schoolId;
  String teacherId;
  int v;

  Datum({
    this.id,
    this.studentId,
    this.title,
    this.date,
    this.schoolId,
    this.teacherId,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        studentId: json["studentId"],
        title: json["title"],
        date: json["date"],
        schoolId: json["schoolId"],
        teacherId: json["teacherId"],
        v: json["__v"],
      );
}
