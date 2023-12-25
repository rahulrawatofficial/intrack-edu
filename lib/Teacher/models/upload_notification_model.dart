// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

String uploadNotificationModelToJson(UploadNotificationModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UploadNotificationModel {
  String title;
  String description;
  List<String> studentId;
  List<String> sectionId;
  String schoolId;

  UploadNotificationModel({
    this.title,
    this.description,
    this.studentId,
    this.sectionId,
    this.schoolId,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "studentId": new List<dynamic>.from(studentId.map((x) => x)),
        "sectionId": new List<dynamic>.from(sectionId.map((x) => x)),
        "schoolId": schoolId,
      };
}
