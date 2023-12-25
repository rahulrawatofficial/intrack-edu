// To parse this JSON data, do
//
//     final courseAttendanceModel = courseAttendanceModelFromJson(jsonString);

import 'dart:convert';

CourseAttendanceModel courseAttendanceModelFromJson(String str) =>
    CourseAttendanceModel.fromJson(json.decode(str));

String courseAttendanceModelToJson(CourseAttendanceModel data) =>
    json.encode(data.toJson());

class CourseAttendanceModel {
  CourseAttendanceModel({
    this.classId,
    this.studentId,
    this.date,
    this.studentAttendance,
  });

  String classId;
  String studentId;
  DateTime date;
  List<StudentAttendance> studentAttendance;

  factory CourseAttendanceModel.fromJson(Map<String, dynamic> json) =>
      CourseAttendanceModel(
        classId: json["classId"],
        studentId: json["studentId"],
        date: DateTime.parse(json["date"]),
        studentAttendance: List<StudentAttendance>.from(
            json["studentAttendance"]
                .map((x) => StudentAttendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "classId": classId,
        "studentId": studentId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "studentAttendance":
            List<dynamic>.from(studentAttendance.map((x) => x.toJson())),
      };
}

class StudentAttendance {
  StudentAttendance({
    this.courseId,
    this.chapterId,
    this.liveClassId,
    this.startTime,
  });

  String courseId;
  String chapterId;
  String liveClassId;
  String startTime;

  factory StudentAttendance.fromJson(Map<String, dynamic> json) =>
      StudentAttendance(
        courseId: json["courseId"],
        chapterId: json["chapterId"],
        liveClassId: json["liveClassId"],
        startTime: json["startTime"],
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "chapterId": chapterId,
        "liveClassId": liveClassId,
        "startTime": startTime,
      };
}
