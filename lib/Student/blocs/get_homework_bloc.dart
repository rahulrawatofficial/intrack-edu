import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/get_homework_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class HomeworkBloc {
  final _repository = HomeworkRepository();
  final _homeworkFetcher = PublishSubject<HomeworkModel>();

  Observable<HomeworkModel> get allHomework => _homeworkFetcher.stream;

  fetchAllHomework(
      String userToken, String studentId, BuildContext context) async {
    HomeworkModel homeworkModel =
        await _repository.fetchAllHomework(userToken, studentId, context);
    _homeworkFetcher.sink.add(homeworkModel);
  }

  dispose() {
    _homeworkFetcher.close();
  }
}

final homeworkBloc = HomeworkBloc();
