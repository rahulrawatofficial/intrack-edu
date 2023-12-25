// To parse this JSON data, do
//
//     final leavesListModel = leavesListModelFromJson(jsonString);

import 'dart:convert';

LeavesListModel leavesListModelFromJson(String str) =>
    LeavesListModel.fromJson(json.decode(str));

String leavesListModelToJson(LeavesListModel data) =>
    json.encode(data.toJson());

class LeavesListModel {
  bool success;
  String message;
  List<Datum> data;

  LeavesListModel({
    this.success,
    this.message,
    this.data,
  });

  factory LeavesListModel.fromJson(Map<String, dynamic> json) =>
      new LeavesListModel(
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
  String id;
  StudentId studentId;
  String leaveTitle;
  String leaveDescription;
  List<LeaveDate> leaveDates;
  String classId;
  String sectionId;
  String schoolId;
  String parentId;
  String status;
  DateTime created;
  int v;

  Datum({
    this.id,
    this.studentId,
    this.leaveTitle,
    this.leaveDescription,
    this.leaveDates,
    this.classId,
    this.sectionId,
    this.schoolId,
    this.parentId,
    this.status,
    this.created,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        studentId: StudentId.fromJson(json["studentId"]),
        leaveTitle: json["leaveTitle"],
        leaveDescription: json["leaveDescription"],
        leaveDates: new List<LeaveDate>.from(
            json["leaveDates"].map((x) => LeaveDate.fromJson(x))),
        classId: json["classId"],
        sectionId: json["sectionId"],
        schoolId: json["schoolId"],
        parentId: json["parentId"],
        status: json["status"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "studentId": studentId.toJson(),
        "leaveTitle": leaveTitle,
        "leaveDescription": leaveDescription,
        "leaveDates": new List<dynamic>.from(leaveDates.map((x) => x.toJson())),
        "classId": classId,
        "sectionId": sectionId,
        "schoolId": schoolId,
        "parentId": parentId,
        "status": status,
        "created": created.toIso8601String(),
        "__v": v,
      };
}

class LeaveDate {
  String id;
  DateTime dateOfLeave;

  LeaveDate({
    this.id,
    this.dateOfLeave,
  });

  factory LeaveDate.fromJson(Map<String, dynamic> json) => new LeaveDate(
        id: json["_id"],
        dateOfLeave: DateTime.parse(json["dateOfLeave"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dateOfLeave": dateOfLeave.toIso8601String(),
      };
}

class StudentId {
  String id;
  String name;

  StudentId({
    this.id,
    this.name,
  });

  factory StudentId.fromJson(Map<String, dynamic> json) => new StudentId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
