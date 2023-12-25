// To parse this JSON data, do
//
//     final timeTableModel = timeTableModelFromJson(jsonString);

import 'dart:convert';

TimeTableModel timeTableModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TimeTableModel.fromJson(jsonData);
}

class TimeTableModel {
  bool success;
  String message;
  Data data;

  TimeTableModel({
    this.success,
    this.message,
    this.data,
  });

  factory TimeTableModel.fromJson(Map<String, dynamic> json) =>
      new TimeTableModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String id;
  String sectionId;
  List<Schedule> schedule;
  String created;
  int v;

  Data({
    this.id,
    this.sectionId,
    this.schedule,
    this.created,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        id: json["_id"],
        sectionId: json["sectionId"],
        schedule: new List<Schedule>.from(
            json["schedule"].map((x) => Schedule.fromJson(x))),
        created: json["created"],
        v: json["__v"],
      );
}

class Schedule {
  List<Lecture> lectures;
  String id;
  String day;

  Schedule({
    this.lectures,
    this.id,
    this.day,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => new Schedule(
        lectures: new List<Lecture>.from(
            json["lectures"].map((x) => Lecture.fromJson(x))),
        id: json["_id"],
        day: json["day"],
      );
}

class Lecture {
  String id;
  String timeIn;
  String timeOut;
  String subjectName;
  String teacherId;

  Lecture({
    this.id,
    this.timeIn,
    this.timeOut,
    this.subjectName,
    this.teacherId,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => new Lecture(
        id: json["_id"],
        timeIn: json["timeIn"],
        timeOut: json["timeOut"],
        subjectName: json["subjectName"],
        teacherId: json["teacherId"],
      );
}
