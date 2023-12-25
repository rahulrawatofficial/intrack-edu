import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/gallery_model.dart';
import 'package:intrack/Student/resources/Gallery/get_gallery_api.dart';

class GalleryRepository {
  final galleryApiProvider = GetGalleryApi();

  Future<GalleryModel> fetchAllGallery(
          String userToken, BuildContext context) =>
      galleryApiProvider.getGallery(userToken, context);
}
