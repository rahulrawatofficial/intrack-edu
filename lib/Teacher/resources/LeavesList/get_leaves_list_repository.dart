import 'dart:async';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/leaves_list_model.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/resources/LeavesList/get_leaves_list_api.dart';
import 'package:intrack/Teacher/resources/StudentsInfoList/students_info_list_api.dart';

class LeavesListRepository {
  final leaveListApiProvider = LeavesListApi();

  Future<LeavesListModel> allLeavesList(String userToken, BuildContext context,
          String sectionId, String status) =>
      leaveListApiProvider.getLeavesList(userToken, context, sectionId, status);
}
