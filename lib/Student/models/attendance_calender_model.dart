// To parse this JSON data, do
//
//     final attendanceCalenderModel = attendanceCalenderModelFromJson(jsonString);

import 'dart:convert';

AttendanceCalenderModel attendanceCalenderModelFromJson(String str) {
  final jsonData = json.decode(str);
  return AttendanceCalenderModel.fromJson(jsonData);
}

class AttendanceCalenderModel {
  bool success;
  String message;
  List<Datum> data;

  AttendanceCalenderModel({
    this.success,
    this.message,
    this.data,
  });

  factory AttendanceCalenderModel.fromJson(Map<String, dynamic> json) =>
      new AttendanceCalenderModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  String id;
  String date;
  List<Student> students;

  Datum({
    this.id,
    this.date,
    this.students,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        date: json["date"],
        students: new List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
      );
}

class Student {
  bool isPresent;
  String id;
  String studentId;

  Student({
    this.isPresent,
    this.id,
    this.studentId,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
        isPresent: json["isPresent"],
        id: json["_id"],
        studentId: json["studentId"],
      );
}
