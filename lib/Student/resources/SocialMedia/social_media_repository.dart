import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/social_media_model.dart';
import 'package:intrack/Student/resources/SocialMedia/social_media_api.dart';

class SocialMediaRepository {
  final socialMediaApiProvider = GetSocialMediaApi();

  Future<SocialMediaModel> fetchAllSocialMedia(
          String userToken, BuildContext context) =>
      socialMediaApiProvider.getSocialMedia(userToken, context);
}
