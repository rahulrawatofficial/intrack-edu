import 'package:flutter/material.dart';
import 'package:intrack/Student/models/result_model.dart';
import 'package:intrack/Student/resources/Result/result_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResultBloc {
  final _repository = ResultRepository();
  final _resultFetcher = PublishSubject<ResultModel>();

  Observable<ResultModel> get allResult => _resultFetcher.stream;

  fetchAllResult(BuildContext context, String userToken, String studentId,
      String sectionId) async {
    ResultModel resultModel =
        await _repository.fetchResult(context, userToken, studentId, sectionId);
    _resultFetcher.sink.add(resultModel);
  }

  dispose() {
    _resultFetcher.close();
  }
}

final resultBloc = ResultBloc();
