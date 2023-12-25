import 'package:intrack/Student/models/social_media_model.dart';
import 'package:intrack/Student/resources/SocialMedia/social_media_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class SocialMediaBloc {
  final _repository = SocialMediaRepository();
  final _socialMediaFetcher = PublishSubject<SocialMediaModel>();

  Observable<SocialMediaModel> get allSocialMedia => _socialMediaFetcher.stream;

  fetchAllSocialMedia(String userToken, BuildContext context) async {
    SocialMediaModel getSocialMediaModel =
        await _repository.fetchAllSocialMedia(userToken, context);
    _socialMediaFetcher.sink.add(getSocialMediaModel);
  }

  dispose() {
    _socialMediaFetcher.close();
  }
}

final socialMediaBloc = SocialMediaBloc();
