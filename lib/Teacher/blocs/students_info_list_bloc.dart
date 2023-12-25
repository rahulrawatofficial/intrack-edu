import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/resources/StudentsInfoList/students_info_list_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class StudentsInfoBloc {
  final _repository = StudentsInfoListRepository();
  final _studentsInfoListFetcher = PublishSubject<StudentsInfoModel>();

  Observable<StudentsInfoModel> get allStudentsInfoList =>
      _studentsInfoListFetcher.stream;

  fetchAllStudentsInfoList(String userToken, BuildContext context,
      String classId, String sectionId) async {
    StudentsInfoModel studentsInfoModel = await _repository.allStudentsInfoList(
        userToken, context, classId, sectionId);
    _studentsInfoListFetcher.sink.add(studentsInfoModel);
  }

  dispose() {
    _studentsInfoListFetcher.close();
  }
}

final studentsInfoBloc = StudentsInfoBloc();
