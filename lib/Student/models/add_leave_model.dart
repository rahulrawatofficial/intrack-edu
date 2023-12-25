// To parse this JSON data, do
//
//     final addLeaveModel = addLeaveModelFromJson(jsonString);

import 'dart:convert';

AddLeaveModel addLeaveModelFromJson(String str) =>
    AddLeaveModel.fromJson(json.decode(str));

String addLeaveModelToJson(AddLeaveModel data) => json.encode(data.toJson());

class AddLeaveModel {
  String leaveTitle;
  String leaveDescription;
  List<LeaveDate> leaveDates;
  String studentId;
  String classId;
  String sectionId;

  AddLeaveModel({
    this.leaveTitle,
    this.leaveDescription,
    this.leaveDates,
    this.studentId,
    this.classId,
    this.sectionId,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) =>
      new AddLeaveModel(
        studentId: json["studentId"],
        leaveTitle: json["leaveTitle"],
        leaveDescription: json["leaveDescription"],
        leaveDates: new List<LeaveDate>.from(
            json["leaveDates"].map((x) => LeaveDate.fromJson(x))),
        classId: json["classId"],
        sectionId: json["sectionId"],
      );

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "leaveTitle": leaveTitle,
        "leaveDescription": leaveDescription,
        "leaveDates": new List<dynamic>.from(leaveDates.map((x) => x.toJson())),
        "classId": classId,
        "sectionId": sectionId,
      };
}

class LeaveDate {
  String dateOfLeave;

  LeaveDate({
    this.dateOfLeave,
  });

  factory LeaveDate.fromJson(Map<String, dynamic> json) => new LeaveDate(
        dateOfLeave: json["dateOfLeave"],
      );

  Map<String, dynamic> toJson() => {
        "dateOfLeave": dateOfLeave,
      };
}
