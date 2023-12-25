// To parse this JSON data, do
//
//     final getNewsModel = getNewsModelFromJson(jsonString);

import 'dart:convert';

GetNewsModel getNewsModelFromJson(String str) => GetNewsModel.fromJson(json.decode(str));

String getNewsModelToJson(GetNewsModel data) => json.encode(data.toJson());

class GetNewsModel {
    bool success;
    String message;
    List<Datum> data;

    GetNewsModel({
        this.success,
        this.message,
        this.data,
    });

    factory GetNewsModel.fromJson(Map<String, dynamic> json) => new GetNewsModel(
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
    List<String> newsLikes;
    String id;
    String title;
    String description;
    String schoolId;
    List<NewsImageUrl> newsImageUrl;
    DateTime created;
    int v;

    Datum({
        this.newsLikes,
        this.id,
        this.title,
        this.description,
        this.schoolId,
        this.newsImageUrl,
        this.created,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        newsLikes: new List<String>.from(json["newsLikes"].map((x) => x)),
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        schoolId: json["schoolId"],
        newsImageUrl: new List<NewsImageUrl>.from(json["newsImageUrl"].map((x) => NewsImageUrl.fromJson(x))),
        created: DateTime.parse(json["created"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "newsLikes": new List<dynamic>.from(newsLikes.map((x) => x)),
        "_id": id,
        "title": title,
        "description": description,
        "schoolId": schoolId,
        "newsImageUrl": new List<dynamic>.from(newsImageUrl.map((x) => x.toJson())),
        "created": created.toIso8601String(),
        "__v": v,
    };
}

class NewsImageUrl {
    String id;
    String imageUrl;

    NewsImageUrl({
        this.id,
        this.imageUrl,
    });

    factory NewsImageUrl.fromJson(Map<String, dynamic> json) => new NewsImageUrl(
        id: json["_id"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "imageUrl": imageUrl,
    };
}
