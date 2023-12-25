// To parse this JSON data, do
//
//     final particularNewsModel = particularNewsModelFromJson(jsonString);

import 'dart:convert';

ParticularNewsModel particularNewsModelFromJson(String str) => ParticularNewsModel.fromJson(json.decode(str));

String particularNewsModelToJson(ParticularNewsModel data) => json.encode(data.toJson());

class ParticularNewsModel {
    bool success;
    String message;
    Data data;

    ParticularNewsModel({
        this.success,
        this.message,
        this.data,
    });

    factory ParticularNewsModel.fromJson(Map<String, dynamic> json) => new ParticularNewsModel(
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
    List<String> newsLikes;
    String id;
    String title;
    String description;
    String schoolId;
    List<NewsImageUrl> newsImageUrl;
    DateTime created;
    int v;

    Data({
        this.newsLikes,
        this.id,
        this.title,
        this.description,
        this.schoolId,
        this.newsImageUrl,
        this.created,
        this.v,
    });

    factory Data.fromJson(Map<String, dynamic> json) => new Data(
        newsLikes: new List<String>.from(json["newsLikes"].map((x) => x)),
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        schoolId: json["schoolId"],
        newsImageUrl: new List<NewsImageUrl>.from(json["newsImageUrl"].map((x) => NewsImageUrl.fromJson(x))),
        created: DateTime.parse(json["created"]),
        
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
