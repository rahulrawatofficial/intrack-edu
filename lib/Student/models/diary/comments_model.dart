// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

CommentsModel commentsModelFromJson(String str) {
  final jsonData = json.decode(str);
  return CommentsModel.fromJson(jsonData);
}

String commentsModelToJson(CommentsModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CommentsModel {
  bool success;
  String message;
  Data data;

  CommentsModel({
    this.success,
    this.message,
    this.data,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) =>
      new CommentsModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  Id studentId;
  String title;
  String schoolId;
  Id teacherId;
  DateTime date;
  List<dynamic> comments;
  int v;

  Data({
    this.id,
    this.studentId,
    this.title,
    this.schoolId,
    this.teacherId,
    this.date,
    this.comments,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        id: json["_id"],
        studentId: Id.fromJson(json["studentId"]),
        title: json["title"],
        schoolId: json["schoolId"],
        teacherId: Id.fromJson(json["teacherId"]),
        date: DateTime.parse(json["date"]),
        comments: new List<dynamic>.from(json["comments"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "studentId": studentId.toJson(),
        "title": title,
        "schoolId": schoolId,
        "teacherId": teacherId.toJson(),
        "date": date.toIso8601String(),
        "comments": new List<dynamic>.from(comments.map((x) => x)),
        "__v": v,
      };
}

class Id {
  String id;
  String name;

  Id({
    this.id,
    this.name,
  });

  factory Id.fromJson(Map<String, dynamic> json) => new Id(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
