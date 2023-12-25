import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/get_news_model.dart';
import 'package:intrack/Student/models/get_particular_news_model.dart';
import 'package:intrack/Student/resources/ParticularNews/get_particular_news_api.dart';

class ParticularNewsRepository {
  final newsApiProvider = ParticularNewsApi();

  Future<ParticularNewsModel> fetchAllParticularNews(
          String userToken, BuildContext context, String newsId) =>
      newsApiProvider.getParticularNews(context, userToken, newsId);
}
