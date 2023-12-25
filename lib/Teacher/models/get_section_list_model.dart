// To parse this JSON data, do
//
//     final sectionListModel = sectionListModelFromJson(jsonString);

import 'dart:convert';

SectionListModel sectionListModelFromJson(String str) {
  final jsonData = json.decode(str);
  return SectionListModel.fromJson(jsonData);
}

class SectionListModel {
  bool success;
  String message;
  List<Datum> data;

  SectionListModel({
    this.success,
    this.message,
    this.data,
  });

  factory SectionListModel.fromJson(Map<String, dynamic> json) =>
      new SectionListModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  String id;
  List<dynamic> teachers;
  String name;
  String classId;
  int session;
  String schoolId;
  ClassData classData;
  List<StudentDatum> studentData;
  String timeTableId;

  Datum({
    this.id,
    this.teachers,
    this.name,
    this.classId,
    this.session,
    this.schoolId,
    this.classData,
    this.studentData,
    this.timeTableId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        teachers: new List<dynamic>.from(json["teachers"].map((x) => x)),
        name: json["name"],
        classId: json["classId"],
        session: json["session"] == null ? null : json["session"],
        schoolId: json["schoolId"],
        classData: ClassData.fromJson(json["classData"]),
        studentData: new List<StudentDatum>.from(
            json["studentData"].map((x) => StudentDatum.fromJson(x))),
        timeTableId: json["timeTableId"] == null ? null : json["timeTableId"],
      );
}

class ClassData {
  int classNum;

  ClassData({
    this.classNum,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) => new ClassData(
        classNum: json["classNum"],
      );
}

class StudentDatum {
  String id;
  String email;
  String name;

  StudentDatum({
    this.id,
    this.email,
    this.name,
  });

  factory StudentDatum.fromJson(Map<String, dynamic> json) => new StudentDatum(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
      );
}
