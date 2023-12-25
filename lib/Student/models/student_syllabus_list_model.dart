// To parse this JSON data, do
//
//     final studentSyllabusListModel = studentSyllabusListModelFromJson(jsonString);

import 'dart:convert';

StudentSyllabusListModel studentSyllabusListModelFromJson(String str) =>
    StudentSyllabusListModel.fromJson(json.decode(str));

String studentSyllabusListModelToJson(StudentSyllabusListModel data) =>
    json.encode(data.toJson());

class StudentSyllabusListModel {
  bool success;
  String message;
  List<Datum> data;

  StudentSyllabusListModel({
    this.success,
    this.message,
    this.data,
  });

  factory StudentSyllabusListModel.fromJson(Map<String, dynamic> json) =>
      StudentSyllabusListModel(
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
  ClassId classId;
  String title;
  String description;
  String fileType;
  String documentUrl;
  SchoolIdClass schoolId;
  SchoolIdClass teacherId;
  DateTime created;
  int v;
  String sectionId;

  Datum({
    this.id,
    this.classId,
    this.title,
    this.description,
    this.fileType,
    this.documentUrl,
    this.schoolId,
    this.teacherId,
    this.created,
    this.v,
    this.sectionId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        classId:
            json["classId"] != null ? ClassId.fromJson(json["classId"]) : null,
        title: json["title"],
        description: json["description"],
        fileType: json["fileType"] == null ? null : json["fileType"],
        documentUrl: json["documentUrl"] == null ? null : json["documentUrl"],
        schoolId: SchoolIdClass.fromJson(json["schoolId"]),
        teacherId: json["teacherId"] == null
            ? null
            : SchoolIdClass.fromJson(json["teacherId"]),
        created: DateTime.parse(json["created"]),
        v: json["__v"],
        sectionId: json["sectionId"] == null ? null : json["sectionId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classId": classId.toJson(),
        "title": title,
        "description": description,
        "fileType": fileType == null ? null : fileType,
        "documentUrl": documentUrl == null ? null : documentUrl,
        "schoolId": schoolId.toJson(),
        "teacherId": teacherId == null ? null : teacherId.toJson(),
        "created": created.toIso8601String(),
        "__v": v,
        "sectionId": sectionId == null ? null : sectionId,
      };
}

class ClassId {
  String id;

  ClassId({
    this.id,
  });

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}

class SchoolIdClass {
  String id;
  String name;

  SchoolIdClass({
    this.id,
    this.name,
  });

  factory SchoolIdClass.fromJson(Map<String, dynamic> json) => SchoolIdClass(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
