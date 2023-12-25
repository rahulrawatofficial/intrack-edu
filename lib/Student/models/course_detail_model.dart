// To parse this JSON data, do
//
//     final courseDetailModel = courseDetailModelFromJson(jsonString);

import 'dart:convert';

CourseDetailModel courseDetailModelFromJson(String str) =>
    CourseDetailModel.fromJson(json.decode(str));

String courseDetailModelToJson(CourseDetailModel data) =>
    json.encode(data.toJson());

class CourseDetailModel {
  CourseDetailModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailModel(
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
    this.courseName,
    this.courseImageUrl,
    this.schoolId,
    this.teacherId,
    this.enrollStudents,
    this.created,
    this.v,
    this.assignedTeacher,
  });

  String id;
  String classId;
  String courseName;
  String courseImageUrl;
  String schoolId;
  String teacherId;
  List<EnrollStudent> enrollStudents;
  DateTime created;
  int v;
  List<AssignedTeacher> assignedTeacher;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        classId: json["classId"],
        courseName: json["courseName"],
        courseImageUrl: json["courseImageUrl"],
        schoolId: json["schoolId"],
        teacherId: json["teacherId"] == null ? null : json["teacherId"],
        enrollStudents: List<EnrollStudent>.from(
            json["enrollStudents"].map((x) => EnrollStudent.fromJson(x))),
        created: DateTime.parse(json["created"]),
        v: json["__v"],
        assignedTeacher: List<AssignedTeacher>.from(
            json["assignedTeacher"].map((x) => AssignedTeacher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classId": classId,
        "courseName": courseName,
        "courseImageUrl": courseImageUrl,
        "schoolId": schoolId,
        "teacherId": teacherId == null ? null : teacherId,
        "enrollStudents":
            List<dynamic>.from(enrollStudents.map((x) => x.toJson())),
        "created": created.toIso8601String(),
        "__v": v,
        "assignedTeacher":
            List<dynamic>.from(assignedTeacher.map((x) => x.toJson())),
      };
}

class AssignedTeacher {
  AssignedTeacher({
    this.id,
    this.teacherId,
  });

  String id;
  String teacherId;

  factory AssignedTeacher.fromJson(Map<String, dynamic> json) =>
      AssignedTeacher(
        id: json["_id"],
        teacherId: json["teacherId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "teacherId": teacherId,
      };
}

class EnrollStudent {
  EnrollStudent({
    this.id,
    this.studentId,
  });

  String id;
  String studentId;

  factory EnrollStudent.fromJson(Map<String, dynamic> json) => EnrollStudent(
        id: json["_id"],
        studentId: json["studentId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "studentId": studentId,
      };
}
