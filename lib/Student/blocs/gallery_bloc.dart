import 'package:intrack/Student/models/gallery_model.dart';
import 'package:intrack/Student/resources/Gallery/get_gallery_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class GalleryBloc {
  final _repository = GalleryRepository();
  final _galleryFetcher = PublishSubject<GalleryModel>();

  Observable<GalleryModel> get allGallery => _galleryFetcher.stream;

  fetchAllGallery(String userToken, BuildContext context) async {
    GalleryModel getGalleryModel =
        await _repository.fetchAllGallery(userToken, context);
    _galleryFetcher.sink.add(getGalleryModel);
  }

  dispose() {
    _galleryFetcher.close();
  }
}

final galleryBloc = GalleryBloc();
