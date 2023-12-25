import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/resultOverall_model.dart';
import 'package:intrack/Student/resources/ResultOverall/result_api.dart';

class ResultOverallRepository {
  final resultApi = ResultOverallApi();

  Future<ResultOverallModel> fetchResult(BuildContext context, String userToken,
          String studentId, String sectionId) =>
      resultApi.getResultOverall(
        context,
        userToken,
        studentId,
        sectionId,
      );
}
