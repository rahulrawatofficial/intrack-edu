// To parse this JSON data, do
//
//     final getStudentsListModel = getStudentsListModelFromJson(jsonString);

import 'dart:convert';

StudentsListModel studentsListModelFromJson(String str) {
  final jsonData = json.decode(str);
  return StudentsListModel.fromJson(jsonData);
}

String studentsListModelToJson(StudentsListModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class StudentsListModel {
  bool success;
  String message;
  Data data;

  StudentsListModel({
    this.success,
    this.message,
    this.data,
  });

  factory StudentsListModel.fromJson(Map<String, dynamic> json) =>
      new StudentsListModel(
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
  List<Student> students;
  String id;

  Data({
    this.students,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        students: new List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "students": new List<dynamic>.from(students.map((x) => x.toJson())),
        "_id": id,
      };
}

class Student {
  String id;
  String name;

  Student({
    this.id,
    this.name,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
