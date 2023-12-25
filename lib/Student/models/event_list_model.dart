// To parse this JSON data, do
//
//     final eventListModel = eventListModelFromJson(jsonString);

import 'dart:convert';

EventListModel eventListModelFromJson(String str) =>
    EventListModel.fromJson(json.decode(str));

String eventListModelToJson(EventListModel data) => json.encode(data.toJson());

class EventListModel {
  bool success;
  String message;
  List<Datum> data;

  EventListModel({
    this.success,
    this.message,
    this.data,
  });

  factory EventListModel.fromJson(Map<String, dynamic> json) => EventListModel(
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
  String id;
  Event event;

  Datum({
    this.id,
    this.event,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        event: json["event"] != null ? Event.fromJson(json["event"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "event": event != null ? event.toJson() : null,
      };
}

class Event {
  String id;
  String title;
  String description;
  String fileType;
  String eventImageUrl;
  DateTime created;

  Event({
    this.id,
    this.title,
    this.description,
    this.fileType,
    this.eventImageUrl,
    this.created,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        fileType: json["fileType"],
        eventImageUrl: json["eventImageUrl"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "fileType": fileType,
        "eventImageUrl": eventImageUrl,
        "created": created.toIso8601String(),
      };
}
