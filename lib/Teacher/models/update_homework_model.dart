// To parse this JSON data, do
//
//     final uploadHomeworkModel = uploadHomeworkModelFromJson(jsonString);

import 'dart:convert';

String updateHomeworkModelToJson(UpdateHomeworkModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

String updateHomeworkModelNoAttachToJson(UpdateHomeworkModelNoAttach data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UpdateHomeworkModel {
  String subjectName;
  String problems;
  String subjectHomeWorkId;
  String sectionId;
  String homeworkId;
  Homework homework;
  String upload;

  UpdateHomeworkModel({
    this.sectionId,
    this.homeworkId,
    this.homework,
    this.subjectHomeWorkId,
    this.problems,
    this.subjectName,
    this.upload,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "homeworkId": homeworkId,
        // "homework": homework.toJson(),
        "subjectHomeWorkId": subjectHomeWorkId,
        "subjectName": subjectName,
        "problems": problems,
        "upload": upload,
      };
}

class UpdateHomeworkModelNoAttach {
  String subjectName;
  String problems;
  String subjectHomeWorkId;

  String sectionId;
  String homeworkId;
  HomeworkNoAttach homework;

  UpdateHomeworkModelNoAttach({
    this.sectionId,
    this.homeworkId,
    this.homework,
    this.subjectHomeWorkId,
    this.problems,
    this.subjectName,
  });

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "homeworkId": homeworkId,
        // "homework": homework.toJson(),
        "subjectHomeWorkId": subjectHomeWorkId,
        "subjectName": subjectName,
        "problems": problems,
      };
}

class Homework {
  String subjectName;
  String problems;
  String upload;
  String fileType;

  Homework({
    this.subjectName,
    this.problems,
    this.upload,
    this.fileType,
  });

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "problems": problems,
        "upload": upload,
        "fileType": fileType,
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
