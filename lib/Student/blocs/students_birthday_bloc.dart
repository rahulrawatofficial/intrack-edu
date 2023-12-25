import 'package:intrack/Student/models/students_birthday_model.dart';
import 'package:intrack/Student/resources/Birthdays/student_birthdays_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class StudentsBirthdayBloc {
  final _repository = StudentsBirthdayRepository();
  final _studentsBirthdayListFetcher = PublishSubject<StudentsBirthdayModel>();

  Observable<StudentsBirthdayModel> get allStudentsBirthdayList =>
      _studentsBirthdayListFetcher.stream;

  fetchAllStudentsBirthdayList(String userToken, BuildContext context,
      String classId, String sectionId) async {
    StudentsBirthdayModel studentsBirthdayModel = await _repository
        .allStudentsBirthdayList(userToken, context, classId, sectionId);
    _studentsBirthdayListFetcher.sink.add(studentsBirthdayModel);
  }

  dispose() {
    _studentsBirthdayListFetcher.close();
  }
}

class StudentsBirthdayListRepository {}

final studentsBirthdayBloc = StudentsBirthdayBloc();
