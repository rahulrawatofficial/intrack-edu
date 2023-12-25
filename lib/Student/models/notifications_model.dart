// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) {
  final jsonData = json.decode(str);
  return NotificationsModel.fromJson(jsonData);
}

String notificationsModelToJson(NotificationsModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class NotificationsModel {
  bool success;
  String message;
  List<Datum> data;

  NotificationsModel({
    this.success,
    this.message,
    this.data,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      new NotificationsModel(
        success: json["success"],
        message: json["message"],
        data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  Notification notification;

  Datum({
    this.id,
    this.notification,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        id: json["_id"],
        notification: Notification.fromJson(json["notification"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "notification": notification.toJson(),
      };
}

class Notification {
  String id;
  String title;
  String description;
  DateTime created;

  Notification({
    this.id,
    this.title,
    this.description,
    this.created,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => new Notification(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "created": created.toIso8601String(),
      };
}
