// To parse this JSON data, do
//
//     final courseContentModel = courseContentModelFromJson(jsonString);

import 'dart:convert';

CourseContentModel courseContentModelFromJson(String str) =>
    CourseContentModel.fromJson(json.decode(str));

String courseContentModelToJson(CourseContentModel data) =>
    json.encode(data.toJson());

class CourseContentModel {
  CourseContentModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CourseContentModel.fromJson(Map<String, dynamic> json) =>
      CourseContentModel(
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
    this.courseId,
    this.chapters,
    this.schoolId,
    this.created,
    this.v,
  });

  String id;
  ClassId classId;
  CourseId courseId;
  List<Chapter> chapters;
  String schoolId;
  DateTime created;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        classId: ClassId.fromJson(json["classId"]),
        courseId: CourseId.fromJson(json["courseId"]),
        chapters: List<Chapter>.from(
            json["chapters"].map((x) => Chapter.fromJson(x))),
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classId": classId.toJson(),
        "courseId": courseId.toJson(),
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}

class Chapter {
  Chapter({
    this.chapterPoints,
    this.id,
    this.chapterName,
    this.description,
    this.pdfFileUrl,
    this.fileName,
    this.pptFileUrl,
  });

  List<String> chapterPoints;
  String id;
  String chapterName;
  String description;
  String pdfFileUrl;
  String fileName;
  String pptFileUrl;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapterPoints: List<String>.from(json["chapterPoints"].map((x) => x)),
        id: json["_id"],
        chapterName: json["chapterName"],
        description: json["description"],
        pdfFileUrl: json["pdfFileUrl"],
        fileName: json["fileName"],
        pptFileUrl: json["pptFileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "chapterPoints": List<dynamic>.from(chapterPoints.map((x) => x)),
        "_id": id,
        "chapterName": chapterName,
        "description": description,
        "pdfFileUrl": pdfFileUrl,
        "fileName": fileName,
        "pptFileUrl": pptFileUrl,
      };
}

class ClassId {
  ClassId({
    this.id,
    this.classNum,
  });

  String id;
  String classNum;

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
        classNum: json["classNum"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "classNum": classNum,
      };
}

class CourseId {
  CourseId({
    this.id,
    this.courseName,
  });

  String id;
  String courseName;

  factory CourseId.fromJson(Map<String, dynamic> json) => CourseId(
        id: json["_id"],
        courseName: json["courseName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "courseName": courseName,
      };
}
