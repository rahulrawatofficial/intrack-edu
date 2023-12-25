import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/result_model.dart';
import 'package:intrack/Student/resources/Result/result_api.dart';

class ResultRepository {
  final resultApi = ResultApi();

  Future<ResultModel> fetchResult(BuildContext context, String userToken,
          String studentId, String sectionId) =>
      resultApi.getResult(context, userToken, studentId, sectionId);
}
