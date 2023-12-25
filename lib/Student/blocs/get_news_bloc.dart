import 'package:intrack/Student/models/get_news_model.dart';
import 'package:intrack/Student/resources/News/get_news_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<GetNewsModel>();

  Observable<GetNewsModel> get allNews => _newsFetcher.stream;

  fetchAllNews(String userToken, BuildContext context) async {
    GetNewsModel getNewsModel =
        await _repository.fetchAllNews(userToken, context);
    _newsFetcher.sink.add(getNewsModel);
  }

  dispose() {
    _newsFetcher.close();
  }
}

final newsBloc = NewsBloc();
