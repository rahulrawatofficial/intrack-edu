// To parse this JSON data, do
//
//     final studentsBirthdayModel = studentsBirthdayModelFromJson(jsonString);

import 'dart:convert';

StudentsBirthdayModel studentsBirthdayModelFromJson(String str) =>
    StudentsBirthdayModel.fromJson(json.decode(str));

String studentsBirthdayModelToJson(StudentsBirthdayModel data) =>
    json.encode(data.toJson());

class StudentsBirthdayModel {
  bool success;
  String message;
  List<Datum> data;

  StudentsBirthdayModel({
    this.success,
    this.message,
    this.data,
  });

  factory StudentsBirthdayModel.fromJson(Map<String, dynamic> json) =>
      StudentsBirthdayModel(
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
  String name;
  DateTime dob;
  String profilePicUrl;

  Datum({
    this.id,
    this.name,
    this.dob,
    this.profilePicUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        dob: DateTime.parse(json["dob"]),
        profilePicUrl: json["profilePicUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "dob": dob.toIso8601String(),
        "profilePicUrl": profilePicUrl,
      };
}
