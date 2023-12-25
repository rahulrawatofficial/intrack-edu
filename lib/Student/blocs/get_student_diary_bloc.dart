import 'package:intrack/Student/models/diary/get_student_diary_model.dart';
import 'package:intrack/Student/resources/Diary/get_student_diary_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class GetStudentDiaryBloc {
  final _repository = GetStudentDiaryRepository();
  final _getStudentDiaryFetcher = PublishSubject<GetStudentDiaryModel>();

  Observable<GetStudentDiaryModel> get allDiary =>
      _getStudentDiaryFetcher.stream;

  fetchAllDiary(
      String userToken, BuildContext context, String studentId) async {
    GetStudentDiaryModel getStudentDiaryModel = await _repository.fetchAllDiary(
      userToken,
      context,
      studentId,
    );
    _getStudentDiaryFetcher.sink.add(getStudentDiaryModel);
  }

  dispose() {
    _getStudentDiaryFetcher.close();
  }
}

final getStudentDiaryBloc = GetStudentDiaryBloc();
