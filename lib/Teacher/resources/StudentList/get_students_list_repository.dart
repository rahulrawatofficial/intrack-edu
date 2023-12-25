import 'dart:async';
import 'package:intrack/Teacher/models/get_students_list_model.dart';
import 'package:intrack/Teacher/resources/StudentList/get_students_list_api.dart';

class StudentsListRepository {
  final studentsListApi = StudentsListApi();

  Future<StudentsListModel> fetchAllStudentsList(String userToken) =>
      studentsListApi.getStudentList(userToken);
}
