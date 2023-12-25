import 'package:intrack/Student/models/get_particular_news_model.dart';
import 'package:intrack/Student/resources/ParticularNews/get_particular_news_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class ParticularNewsBloc {
  final _repository = ParticularNewsRepository();
  final _particularNewsFetcher = PublishSubject<ParticularNewsModel>();

  Observable<ParticularNewsModel> get allParticularNews =>
      _particularNewsFetcher.stream;

  fetchAllParticularNews(
      String userToken, BuildContext context, String newsId) async {
    ParticularNewsModel particularNewsModel =
        await _repository.fetchAllParticularNews(userToken, context, newsId);
    _particularNewsFetcher.sink.add(particularNewsModel);
  }

  dispose() {
    _particularNewsFetcher.close();
  }
}

final particularNewsBloc = ParticularNewsBloc();
