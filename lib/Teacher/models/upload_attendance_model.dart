// To parse this JSON data, do
//
// final uploadattendanceModel = uploadattendanceModelFromJson(jsonString);

import 'dart:convert';

String uploadAttendanceModelToJson(UploadAttendanceModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UploadAttendanceModel {
  String sectionId;
  String date;
  List<Student> students;

  UploadAttendanceModel({
    this.sectionId,
    this.date,
    this.students,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "date": date,
        "students": new List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

class Student {
  String studentId;
  bool isPresent;

  Student({
    this.studentId,
    this.isPresent,
  });

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "isPresent": isPresent,
      };
}
