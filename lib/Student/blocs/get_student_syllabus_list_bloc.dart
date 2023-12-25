import 'package:intrack/Student/models/student_syllabus_list_model.dart';
import 'package:intrack/Student/resources/Syllabus/student_syllabus_list_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class GetStudentSyllabusListBloc {
  final _repository = GetStudentSyllabusRepository();
  final _studentSyllabusListFetcher =
      PublishSubject<StudentSyllabusListModel>();

  Observable<StudentSyllabusListModel> get allStudentSyllabusList =>
      _studentSyllabusListFetcher.stream;

  fetchAllSyllabusList(
      String userToken, String sectionId, BuildContext context) async {
    StudentSyllabusListModel studentSyllabusListModel = await _repository
        .fetchAllStudentSyllabusList(userToken, sectionId, context);
    _studentSyllabusListFetcher.sink.add(studentSyllabusListModel);
  }

  dispose() {
    _studentSyllabusListFetcher.close();
  }
}

final getStudentSyllabusListBloc = GetStudentSyllabusListBloc();
