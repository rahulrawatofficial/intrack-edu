import 'package:flutter/material.dart';
import 'package:intrack/Student/models/resultOverall_model.dart';
import 'package:intrack/Student/resources/ResultOverall/result_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResultOverallBloc {
  final _repository = ResultOverallRepository();
  final _resultFetcher = PublishSubject<ResultOverallModel>();

  Observable<ResultOverallModel> get allResult => _resultFetcher.stream;

  fetchAllResult(BuildContext context, String userToken, String studentId,
      String sectionId) async {
    ResultOverallModel resultModel =
        await _repository.fetchResult(context, userToken, studentId, sectionId);
    _resultFetcher.sink.add(resultModel);
  }

  dispose() {
    _resultFetcher.close();
  }
}

final resultBloc = ResultOverallBloc();
