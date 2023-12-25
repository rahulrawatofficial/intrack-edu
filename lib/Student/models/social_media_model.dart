// To parse this JSON data, do
//
//     final socialMediaModel = socialMediaModelFromJson(jsonString);

import 'dart:convert';

SocialMediaModel socialMediaModelFromJson(String str) =>
    SocialMediaModel.fromJson(json.decode(str));

String socialMediaModelToJson(SocialMediaModel data) =>
    json.encode(data.toJson());

class SocialMediaModel {
  bool success;
  String message;
  List<Datum> data;

  SocialMediaModel({
    this.success,
    this.message,
    this.data,
  });

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) =>
      SocialMediaModel(
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
  String type;
  String linkUrl;
  String schoolId;
  DateTime created;
  int v;

  Datum({
    this.id,
    this.type,
    this.linkUrl,
    this.schoolId,
    this.created,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        type: json["type"],
        linkUrl: json["linkUrl"],
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "linkUrl": linkUrl,
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}
