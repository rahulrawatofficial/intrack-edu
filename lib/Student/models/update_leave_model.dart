// To parse this JSON data, do
//
//     final addLeaveModel = addLeaveModelFromJson(jsonString);

import 'dart:convert';

UpdateLeaveModel addLeaveModelFromJson(String str) =>
    UpdateLeaveModel.fromJson(json.decode(str));

String updateLeaveModelToJson(UpdateLeaveModel data) =>
    json.encode(data.toJson());

class UpdateLeaveModel {
  String leaveTitle;
  String leaveDescription;
  List<LeaveDate> leaveDates;
  String leaveId;
  String studentId;
  String classId;
  String sectionId;

  UpdateLeaveModel({
    this.leaveTitle,
    this.leaveDescription,
    this.leaveDates,
    this.leaveId,
    this.studentId,
    this.classId,
    this.sectionId,
  });

  factory UpdateLeaveModel.fromJson(Map<String, dynamic> json) =>
      new UpdateLeaveModel(
        studentId: json["studentId"],
        leaveTitle: json["leaveTitle"],
        leaveId: json["leaveId"],
        leaveDescription: json["leaveDescription"],
        leaveDates: new List<LeaveDate>.from(
            json["leaveDates"].map((x) => LeaveDate.fromJson(x))),
        classId: json["classId"],
        sectionId: json["sectionId"],
      );

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "leaveTitle": leaveTitle,
        "leaveId": leaveId,
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
