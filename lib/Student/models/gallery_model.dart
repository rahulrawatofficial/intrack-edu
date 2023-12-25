// To parse this JSON data, do
//
//     final galleryModel = galleryModelFromJson(jsonString);

import 'dart:convert';

GalleryModel galleryModelFromJson(String str) =>
    GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
  bool success;
  String message;
  List<Datum> data;

  GalleryModel({
    this.success,
    this.message,
    this.data,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) => GalleryModel(
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
  List<YouTubeLinkUrl> youTubeLinkUrl;
  String title;
  String description;
  List<ImageUrl> imageUrl;
  String schoolId;
  DateTime created;
  int v;

  Datum({
    this.id,
    this.youTubeLinkUrl,
    this.title,
    this.description,
    this.imageUrl,
    this.schoolId,
    this.created,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        youTubeLinkUrl: List<YouTubeLinkUrl>.from(
            json["youTubeLinkUrl"].map((x) => YouTubeLinkUrl.fromJson(x))),
        title: json["title"],
        description: json["description"],
        imageUrl: List<ImageUrl>.from(
            json["imageUrl"].map((x) => ImageUrl.fromJson(x))),
        schoolId: json["schoolId"],
        created: DateTime.parse(json["created"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "youTubeLinkUrl":
            List<dynamic>.from(youTubeLinkUrl.map((x) => x.toJson())),
        "title": title,
        "description": description,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x.toJson())),
        "schoolId": schoolId,
        "created": created.toIso8601String(),
        "__v": v,
      };
}

class ImageUrl {
  String id;
  String imageLink;

  ImageUrl({
    this.id,
    this.imageLink,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
        id: json["_id"],
        imageLink: json["imageLink"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "imageLink": imageLink,
      };
}

class YouTubeLinkUrl {
  String id;
  String youTubeLink;

  YouTubeLinkUrl({
    this.id,
    this.youTubeLink,
  });

  factory YouTubeLinkUrl.fromJson(Map<String, dynamic> json) => YouTubeLinkUrl(
        id: json["_id"],
        youTubeLink: json["youTubeLink"] == null ? null : json["youTubeLink"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "youTubeLink": youTubeLink == null ? null : youTubeLink,
      };
}
