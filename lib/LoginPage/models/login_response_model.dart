// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginResponseModel.fromJson(jsonData);
}

class LoginResponseModel {
  bool success;
  String message;
  Data data;

  LoginResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      new LoginResponseModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  bool success;
  String message;
  String token;
  String id;
  String role;
  String name;
  String profilePicUrl;

  Data({
    this.success,
    this.message,
    this.token,
    this.id,
    this.role,
    this.name,
    this.profilePicUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
      success: json["success"],
      message: json["message"],
      token: json["token"],
      id: json["id"],
      role: json["role"],
      name: json["name"],
      profilePicUrl: json["profilePicUrl"]);
}
