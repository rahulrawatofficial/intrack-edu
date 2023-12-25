// To parse this JSON data, do
//
//     final previousAttendanceModel = previousAttendanceModelFromJson(jsonString);

import 'dart:convert';

PreviousAttendanceModel previousAttendanceModelFromJson(String str) =>
    PreviousAttendanceModel.fromJson(json.decode(str));

String previousAttendanceModelToJson(PreviousAttendanceModel data) =>
    json.encode(data.toJson());

class PreviousAttendanceModel {
  bool success;
  String message;
  List<Datum> data;

  PreviousAttendanceModel({
    this.success,
    this.message,
    this.data,
  });

  factory PreviousAttendanceModel.fromJson(Map<String, dynamic> json) =>
      PreviousAttendanceModel(
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
  String id;
  String sectionId;
  DateTime date;
  List<Student> students;
  String teacherId;
  int v;

  Datum({
    this.id,
    this.sectionId,
    this.date,
    this.students,
    this.teacherId,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        sectionId: json["sectionId"],
        date: DateTime.parse(json["date"]),
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
        teacherId: json["teacherId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sectionId": sectionId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
        "teacherId": teacherId,
        "__v": v,
      };
}

class Student {
  bool isPresent;
  String id;
  StudentId studentId;

  Student({
    this.isPresent,
    this.id,
    this.studentId,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        isPresent: json["isPresent"],
        id: json["_id"],
        studentId: StudentId.fromJson(json["studentId"]),
      );

  Map<String, dynamic> toJson() => {
        "isPresent": isPresent,
        "_id": id,
        "studentId": studentId.toJson(),
      };
}

class StudentId {
  String id;
  String name;
  String email;
  String profilePicUrl;

  StudentId({
    this.id,
    this.name,
    this.email,
    this.profilePicUrl,
  });

  factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        profilePicUrl: json["profilePicUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "profilePicUrl": profilePicUrl,
      };
}
