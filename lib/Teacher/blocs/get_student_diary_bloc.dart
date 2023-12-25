import 'package:intrack/Teacher/models/get_teacher_diary_model.dart';
import 'package:intrack/Teacher/resources/TeacherDiary/get_teacher_diary_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class GetTeacherDiaryBloc {
  final _repository = GetTeacherDiaryRepository();
  final _getTeacherDiaryFetcher = PublishSubject<GetTeacherDiaryModel>();

  Observable<GetTeacherDiaryModel> get allDiary =>
      _getTeacherDiaryFetcher.stream;

  fetchAllDiary(String userToken, BuildContext context) async {
    GetTeacherDiaryModel getTeacherDiaryModel =
        await _repository.fetchAllDiary(userToken, context);
    _getTeacherDiaryFetcher.sink.add(getTeacherDiaryModel);
  }

  dispose() {
    _getTeacherDiaryFetcher.close();
  }
}

final getTeacherDiaryBloc = GetTeacherDiaryBloc();
