import 'package:intrack/Teacher/models/leaves_list_model.dart';
import 'package:intrack/Teacher/resources/LeavesList/get_leaves_list_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class LeavesListBloc {
  final _repository = LeavesListRepository();
  final _leavesListFetcher = PublishSubject<LeavesListModel>();

  Observable<LeavesListModel> get allLeavesList => _leavesListFetcher.stream;

  fetchAllLeavesList(String userToken, BuildContext context, String classId,
      String sectionId, String status) async {
    LeavesListModel studentsInfoModel = await _repository.allLeavesList(
      userToken,
      context,
      sectionId,
      status,
    );
    _leavesListFetcher.sink.add(studentsInfoModel);
  }

  dispose() {
    _leavesListFetcher.close();
  }
}

final leavesListBloc = LeavesListBloc();
