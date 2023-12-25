// To parse this JSON data, do
//
//     final uploadSyllabusModel = uploadSyllabusModelFromJson(jsonString);

import 'dart:convert';

String uploadSyllabusModelToJson(UploadSyllabusModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

String uploadSyllabusModelNoAttachToJson(UploadSyllabusModelNoAttach data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UploadSyllabusModel {
  String sectionId;
  String classId;
  String title;
  String description;
  String upload;
  String fileType;
  String fileName;

  UploadSyllabusModel({
    this.sectionId,
    this.classId,
    this.title,
    this.description,
    this.upload,
    this.fileType,
    this.fileName,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "classId": classId,
        "title": title,
        "description": description,
        "upload": upload,
        "fileType": fileType,
        "fileName": fileName,
      };
}

class UploadSyllabusModelNoAttach {
  String sectionId;
  String classId;
  String title;
  String description;

  UploadSyllabusModelNoAttach({
    this.sectionId,
    this.classId,
    this.title,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "classId": classId,
        "title": title,
        "description": description,
      };
}
