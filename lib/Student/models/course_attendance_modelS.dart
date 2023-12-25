// To parse this JSON data, do
//
//     final courseAttendanceModelS = courseAttendanceModelSFromJson(jsonString);

import 'dart:convert';

CourseAttendanceModelS courseAttendanceModelSFromJson(String str) =>
    CourseAttendanceModelS.fromJson(json.decode(str));

String courseAttendanceModelSToJson(CourseAttendanceModelS data) =>
    json.encode(data.toJson());

class CourseAttendanceModelS {
  CourseAttendanceModelS({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CourseAttendanceModelS.fromJson(Map<String, dynamic> json) =>
      CourseAttendanceModelS(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.classId,
    this.studentId,
    this.date,
    this.studentAttendance,
    this.schoolId,
    this.created,
    this.v,
  });

  String id;
  ClassId classId;
  String studentId;
  DateTime date;
  List<StudentAttendance> studentAttendance;
  String schoolId;
  DateTime created;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        classId: ClassId.fromJson(json["classId"]),
        studentId: json["studentId"],
        date: DateTime.parse(json["date"]),
        studentAttendance: List<StudentAttendance>.from(
            json["studentAttendance"]
                .map((x) => StudentAttendance.fromJson(x))),
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classId": classId.toJson(),
        "studentId": studentId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "studentAttendance":
            List<dynamic>.from(studentAttendance.map((x) => x.toJson())),
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}

class ClassId {
  ClassId({
    this.id,
    this.classNum,
  });

  String id;
  String classNum;

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
        classNum: json["classNum"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classNum": classNum,
      };
}

class StudentAttendance {
  StudentAttendance({
    this.id,
    this.courseId,
    this.chapterId,
    this.liveClassId,
    this.startTime,
    this.endTime,
  });

  String id;
  CourseId courseId;
  String chapterId;
  String liveClassId;
  String startTime;
  String endTime;

  factory StudentAttendance.fromJson(Map<String, dynamic> json) =>
      StudentAttendance(
        id: json["_id"],
        courseId: CourseId.fromJson(json["courseId"]),
        chapterId: json["chapterId"],
        liveClassId: json["liveClassId"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "courseId": courseId.toJson(),
        "chapterId": chapterId,
        "liveClassId": liveClassId,
        "startTime": startTime,
        "endTime": endTime,
      };
}

class CourseId {
  CourseId({
    this.id,
    this.courseName,
  });

  String id;
  String courseName;

  factory CourseId.fromJson(Map<String, dynamic> json) => CourseId(
        id: json["_id"],
        courseName: json["courseName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "courseName": courseName,
      };
}
