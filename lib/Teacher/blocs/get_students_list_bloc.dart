import 'package:intrack/Teacher/models/get_students_list_model.dart';
import 'package:intrack/Teacher/resources/StudentList/get_students_list_repository.dart';
import 'package:rxdart/rxdart.dart';

class StudentsListBloc {
  final _repository = StudentsListRepository();
  final _studentsListFetcher = PublishSubject<StudentsListModel>();

  Observable<StudentsListModel> get allStudentsList =>
      _studentsListFetcher.stream;

  fetchAllHomework(String userToken) async {
    StudentsListModel studentsListModel =
        await _repository.fetchAllStudentsList(userToken);
    _studentsListFetcher.sink.add(studentsListModel);
  }

  dispose() {
    _studentsListFetcher.close();
  }
}

final studentsListBloc = StudentsListBloc();
