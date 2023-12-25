import 'package:intrack/Teacher/models/previous_homework_model.dart';
import 'package:intrack/Teacher/models/teacher_syllabus_list_model.dart';
import 'package:intrack/Teacher/resources/Homework/get_previous_homework_repository.dart';
import 'package:intrack/Teacher/resources/Syllabus/teacher_syllabus_list_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class GetTeacherSyllabusListBloc {
  final _repository = GetTeacherSyllabusRepository();
  final _teacherSyllabusListFetcher =
      PublishSubject<TeacherSyllabusListModel>();

  Observable<TeacherSyllabusListModel> get allTeacherSyllabusList =>
      _teacherSyllabusListFetcher.stream;

  fetchAllSyllabusList(
      String userToken, String sectionId, BuildContext context) async {
    TeacherSyllabusListModel teacherSyllabusListModel = await _repository
        .fetchAllTeacherSyllabusList(userToken, sectionId, context);
    _teacherSyllabusListFetcher.sink.add(teacherSyllabusListModel);
  }

  dispose() {
    _teacherSyllabusListFetcher.close();
  }
}

final getTeacherSyllabusListBloc = GetTeacherSyllabusListBloc();
