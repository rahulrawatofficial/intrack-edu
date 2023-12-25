import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/get_news_model.dart';
import 'package:intrack/Student/resources/News/get_news_api.dart';

class NewsRepository {
  final newsApiProvider = GetNewsApi();

  Future<GetNewsModel> fetchAllNews(String userToken, BuildContext context) =>
      newsApiProvider.getNews(userToken, context);
}
