// To parse this JSON data, do
//
//     final schoolEventModel = schoolEventModelFromJson(jsonString);

import 'dart:convert';

SchoolEventModel schoolEventModelFromJson(String str) =>
    SchoolEventModel.fromJson(json.decode(str));

String schoolEventModelToJson(SchoolEventModel data) =>
    json.encode(data.toJson());

class SchoolEventModel {
  bool success;
  String message;
  List<Datum> data;

  SchoolEventModel({
    this.success,
    this.message,
    this.data,
  });

  factory SchoolEventModel.fromJson(Map<String, dynamic> json) =>
      SchoolEventModel(
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
  String title;
  DateTime dateOfEvent;
  String description;
  String schoolId;
  DateTime created;
  int v;

  Datum({
    this.id,
    this.title,
    this.dateOfEvent,
    this.description,
    this.schoolId,
    this.created,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        dateOfEvent: DateTime.parse(json["dateOfEvent"]),
        description: json["description"],
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "dateOfEvent":
            "${dateOfEvent.year.toString().padLeft(4, '0')}-${dateOfEvent.month.toString().padLeft(2, '0')}-${dateOfEvent.day.toString().padLeft(2, '0')}",
        "description": description,
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}
