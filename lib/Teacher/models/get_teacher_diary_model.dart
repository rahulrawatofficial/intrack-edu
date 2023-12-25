// To parse this JSON data, do
//
//     final getStudentDiaryModel = getStudentDiaryModelFromJson(jsonString);

import 'dart:convert';

GetTeacherDiaryModel getStudentDiaryModelFromJson(String str) {
  final jsonData = json.decode(str);
  return GetTeacherDiaryModel.fromJson(jsonData);
}

class GetTeacherDiaryModel {
  bool success;
  String message;
  List<DatumT> data;

  GetTeacherDiaryModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetTeacherDiaryModel.fromJson(Map<String, dynamic> json) =>
      new GetTeacherDiaryModel(
        success: json["success"],
        message: json["message"],
        data:
            new List<DatumT>.from(json["data"].map((x) => DatumT.fromJson(x))),
      );
}

class DatumT {
  String id;
  String studentId;
  String title;
  String date;
  String schoolId;
  String teacherId;
  int v;

  DatumT({
    this.id,
    this.studentId,
    this.title,
    this.date,
    this.schoolId,
    this.teacherId,
    this.v,
  });

  factory DatumT.fromJson(Map<String, dynamic> json) => new DatumT(
        id: json["_id"],
        studentId: json["studentId"],
        title: json["title"],
        date: json["date"],
        schoolId: json["schoolId"],
        teacherId: json["teacherId"],
        v: json["__v"],
      );
}
