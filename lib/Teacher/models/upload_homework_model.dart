// To parse this JSON data, do
//
//     final uploadHomeworkModel = uploadHomeworkModelFromJson(jsonString);

import 'dart:convert';

String uploadHomeworkModelToJson(UploadHomeworkModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

String uploadHomeworkModelNoAttachToJson(UploadHomeworkModelNoAttach data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UploadHomeworkModel {
  String sectionId;
  String date;
  Homework homework;

  UploadHomeworkModel({
    this.sectionId,
    this.date,
    this.homework,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "date": date,
        "homework": homework.toJson(),
      };
}

class UploadHomeworkModelNoAttach {
  String sectionId;
  String date;
  HomeworkNoAttach homework;

  UploadHomeworkModelNoAttach({
    this.sectionId,
    this.date,
    this.homework,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "date": date,
        "homework": homework.toJson(),
      };
}

class Homework {
  String subjectName;
  String problems;
  String upload;
  String fileType;
  String fileName;

  Homework({
    this.subjectName,
    this.problems,
    this.upload,
    this.fileType,
    this.fileName,
  });

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "problems": problems,
        "upload": upload,
        "fileType": fileType,
        "fileName": fileName,
      };
}

class HomeworkNoAttach {
  String subjectName;
  String problems;

  HomeworkNoAttach({
    this.subjectName,
    this.problems,
  });

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "problems": problems,
      };
}
