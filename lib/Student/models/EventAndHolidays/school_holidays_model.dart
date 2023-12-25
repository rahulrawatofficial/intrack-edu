// To parse this JSON data, do
//
//     final schoolHolidayModel = schoolHolidayModelFromJson(jsonString);

import 'dart:convert';

SchoolHolidayModel schoolHolidayModelFromJson(String str) =>
    SchoolHolidayModel.fromJson(json.decode(str));

String schoolHolidayModelToJson(SchoolHolidayModel data) =>
    json.encode(data.toJson());

class SchoolHolidayModel {
  bool success;
  String message;
  List<Datum> data;

  SchoolHolidayModel({
    this.success,
    this.message,
    this.data,
  });

  factory SchoolHolidayModel.fromJson(Map<String, dynamic> json) =>
      SchoolHolidayModel(
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
  String occasion;
  DateTime dateOfHoliday;
  String schoolId;
  DateTime created;
  int v;

  Datum({
    this.id,
    this.occasion,
    this.dateOfHoliday,
    this.schoolId,
    this.created,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        occasion: json["occasion"],
        dateOfHoliday: DateTime.parse(json["dateOfHoliday"]),
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "occasion": occasion,
        "dateOfHoliday":
            "${dateOfHoliday.year.toString().padLeft(4, '0')}-${dateOfHoliday.month.toString().padLeft(2, '0')}-${dateOfHoliday.day.toString().padLeft(2, '0')}",
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}
