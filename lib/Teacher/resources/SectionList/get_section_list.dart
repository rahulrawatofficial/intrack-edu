import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Teacher/models/get_section_list_model.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GetSectionListApi {
  //To Create Json
  File jsonFile;
  Directory dir;
  String fileName = "myJSONFile.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  Future<SectionListModel> getSectionList(String userToken) async {
    String path = "/v1/getAllSections";
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return SectionListModel.fromJson(json.decode(response.body));
  }
}
