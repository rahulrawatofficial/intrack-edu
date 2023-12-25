// To parse this JSON data, do
//
//     final studentsInfoModel = studentsInfoModelFromJson(jsonString);

import 'dart:convert';

StudentsInfoModel studentsInfoModelFromJson(String str) =>
    StudentsInfoModel.fromJson(json.decode(str));

String studentsInfoModelToJson(StudentsInfoModel data) =>
    json.encode(data.toJson());

class StudentsInfoModel {
  bool success;
  String message;
  List<StudentsDatum> data;

  StudentsInfoModel({
    this.success,
    this.message,
    this.data,
  });

  factory StudentsInfoModel.fromJson(Map<String, dynamic> json) =>
      StudentsInfoModel(
        success: json["success"],
        message: json["message"],
        data: List<StudentsDatum>.from(
            json["data"].map((x) => StudentsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StudentsDatum {
  List<String> homeworks;
  List<Syallabus> syallabus;
  List<String> attendance;
  List<dynamic> reminders;
  List<String> notifications;
  List<String> events;
  List<String> gallery;
  int role;
  bool status;
  String id;
  ParentId parentId;
  String name;
  String email;
  DateTime dob;
  String city;
  String pincode;
  String country;
  String permanentAddress;
  String presentAddress;
  String mobile;
  String state;
  String gender;
  int establishmentYear;
  String classId;
  String sectionId;
  String bloodGroup;
  String medicalNotes;
  String height;
  String weight;
  String rollNo;
  String schoolId;
  String password;
  List<dynamic> previousClasses;
  DateTime created;
  int v;
  String fatherCellNo;
  String fatherName;
  String motherCellNo;
  String motherName;
  String profilePicUrl;

  StudentsDatum({
    this.homeworks,
    this.syallabus,
    this.attendance,
    this.reminders,
    this.notifications,
    this.events,
    this.gallery,
    this.role,
    this.status,
    this.id,
    this.parentId,
    this.name,
    this.email,
    this.dob,
    this.city,
    this.pincode,
    this.country,
    this.permanentAddress,
    this.presentAddress,
    this.mobile,
    this.state,
    this.gender,
    this.establishmentYear,
    this.classId,
    this.sectionId,
    this.bloodGroup,
    this.medicalNotes,
    this.height,
    this.weight,
    this.rollNo,
    this.schoolId,
    this.password,
    this.previousClasses,
    this.created,
    this.v,
    this.fatherCellNo,
    this.fatherName,
    this.motherCellNo,
    this.motherName,
    this.profilePicUrl,
  });

  factory StudentsDatum.fromJson(Map<String, dynamic> json) => StudentsDatum(
        homeworks: List<String>.from(json["homeworks"].map((x) => x)),
        syallabus: List<Syallabus>.from(
            json["syallabus"].map((x) => syallabusValues.map[x])),
        attendance: List<String>.from(json["attendance"].map((x) => x)),
        reminders: List<dynamic>.from(json["reminders"].map((x) => x)),
        notifications: List<String>.from(json["notifications"].map((x) => x)),
        events: List<String>.from(json["events"].map((x) => x)),
        gallery: List<String>.from(json["gallery"].map((x) => x)),
        role: json["role"],
        status: json["status"],
        id: json["_id"],
        parentId: ParentId.fromJson(json["parentId"]),
        name: json["name"],
        email: json["email"],
        dob: DateTime.parse(json["dob"]),
        city: json["city"],
        pincode: json["pincode"],
        country: json["country"],
        permanentAddress: json["permanentAddress"],
        presentAddress: json["presentAddress"],
        mobile: json["mobile"],
        state: json["state"],
        gender: json["gender"],
        establishmentYear: json["establishmentYear"],
        classId: json["classId"],
        sectionId: json["sectionId"],
        bloodGroup: json["bloodGroup"],
        medicalNotes: json["medicalNotes"],
        height: json["height"],
        weight: json["weight"],
        rollNo: json["rollNo"],
        schoolId: json["schoolId"],
        password: json["password"],
        previousClasses:
            List<dynamic>.from(json["previousClasses"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        v: json["__v"],
        fatherCellNo:
            json["fatherCellNo"] == null ? null : json["fatherCellNo"],
        fatherName: json["fatherName"] == null ? null : json["fatherName"],
        motherCellNo:
            json["motherCellNo"] == null ? null : json["motherCellNo"],
        motherName: json["motherName"] == null ? null : json["motherName"],
        profilePicUrl:
            json["profilePicUrl"] == null ? null : json["profilePicUrl"],
      );

  Map<String, dynamic> toJson() => {
        "homeworks": List<dynamic>.from(homeworks.map((x) => x)),
        "syallabus": List<dynamic>.from(
            syallabus.map((x) => syallabusValues.reverse[x])),
        "attendance": List<dynamic>.from(attendance.map((x) => x)),
        "reminders": List<dynamic>.from(reminders.map((x) => x)),
        "notifications": List<dynamic>.from(notifications.map((x) => x)),
        "events": List<dynamic>.from(events.map((x) => x)),
        "gallery": List<dynamic>.from(gallery.map((x) => x)),
        "role": role,
        "status": status,
        "_id": id,
        "parentId": parentId.toJson(),
        "name": name,
        "email": email,
        "dob": dob.toIso8601String(),
        "city": city,
        "pincode": pincode,
        "country": country,
        "permanentAddress": permanentAddress,
        "presentAddress": presentAddress,
        "mobile": mobile,
        "state": state,
        "gender": gender,
        "establishmentYear": establishmentYear,
        "classId": classId,
        "sectionId": sectionId,
        "bloodGroup": bloodGroup,
        "medicalNotes": medicalNotes,
        "height": height,
        "weight": weight,
        "rollNo": rollNo,
        "schoolId": schoolId,
        "password": password,
        "previousClasses": List<dynamic>.from(previousClasses.map((x) => x)),
        "created": created.toIso8601String(),
        "__v": v,
        "fatherCellNo": fatherCellNo == null ? null : fatherCellNo,
        "fatherName": fatherName == null ? null : fatherName,
        "motherCellNo": motherCellNo == null ? null : motherCellNo,
        "motherName": motherName == null ? null : motherName,
        "profilePicUrl": profilePicUrl == null ? null : profilePicUrl,
      };
}

class ParentId {
  String id;
  String fatherCellNo;
  String email;
  String fatherName;
  String motherName;
  String motherCellNo;

  ParentId({
    this.id,
    this.fatherCellNo,
    this.email,
    this.fatherName,
    this.motherName,
    this.motherCellNo,
  });

  factory ParentId.fromJson(Map<String, dynamic> json) => ParentId(
        id: json["_id"],
        fatherCellNo: json["fatherCellNo"],
        email: json["email"],
        fatherName: json["fatherName"],
        motherName: json["motherName"] == null ? null : json["motherName"],
        motherCellNo:
            json["motherCellNo"] == null ? null : json["motherCellNo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fatherCellNo": fatherCellNo,
        "email": email,
        "fatherName": fatherName,
        "motherName": motherName == null ? null : motherName,
        "motherCellNo": motherCellNo == null ? null : motherCellNo,
      };
}

enum Syallabus {
  THE_5_E451_D12_FFB5_A54_A2_F294_BED,
  THE_5_E451_D5_BFFB5_A54_A2_F294_BEE,
  THE_5_E4548_F9_FFB5_A54_A2_F294_C0_C
}

final syallabusValues = EnumValues({
  "5e451d12ffb5a54a2f294bed": Syallabus.THE_5_E451_D12_FFB5_A54_A2_F294_BED,
  "5e451d5bffb5a54a2f294bee": Syallabus.THE_5_E451_D5_BFFB5_A54_A2_F294_BEE,
  "5e4548f9ffb5a54a2f294c0c": Syallabus.THE_5_E4548_F9_FFB5_A54_A2_F294_C0_C
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
