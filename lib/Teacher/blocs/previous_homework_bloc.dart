import 'package:intrack/Teacher/models/previous_homework_model.dart';
import 'package:intrack/Teacher/resources/Homework/get_previous_homework_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class PreviousHomeworkBloc {
  final _repository = PreviousHomeworkRepository();
  final _previousHomeworkFetcher = PublishSubject<PreviousHomeworkModel>();

  Observable<PreviousHomeworkModel> get allPreviousHomework =>
      _previousHomeworkFetcher.stream;

  fetchAllHomework(String userToken, String sectionId, String date,
      BuildContext context) async {
    PreviousHomeworkModel homeworkModel = await _repository
        .fetchAllPreviousHomework(userToken, sectionId, date, context);
    _previousHomeworkFetcher.sink.add(homeworkModel);
  }

  dispose() {
    _previousHomeworkFetcher.close();
  }
}

final previousHomeworkBloc = PreviousHomeworkBloc();
