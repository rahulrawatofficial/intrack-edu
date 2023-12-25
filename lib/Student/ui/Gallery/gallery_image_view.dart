import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/gallery_bloc.dart';
import 'package:intrack/Student/models/gallery_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io' as Io;

class GalleryImageView extends StatefulWidget {
  final String userToken;
  final Datum galleryData;
  GalleryImageView({
    Key key,
    this.userToken,
    this.galleryData,
  }) : super(key: key);
  @override
  _GalleryImageViewState createState() => _GalleryImageViewState();
}

class _GalleryImageViewState extends State<GalleryImageView> {
  double cHeight;
  double cWidth;
  int imageIndex = 0;
  final imgUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      // new Directory('/storage/emulated/0/Intrack').create()
      //     // The created directory is returned as a Future.
      //     .then((Directory directory) {
      //   print(directory.path);
      // });
      var dir = await getExternalStorageDirectory();
      // Io.Directory dir = Io.Directory("/storage/emulated/0/Intrack");
      await dio.download(widget.galleryData.imageUrl[imageIndex].imageLink,
          "${dir.path}/myimage.jpg", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        print(dir.path);

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Image Downloaded'),
      ),
    );
    // Scaffold.of(context)
    //     .showSnackBar(new SnackBar(content: new Text("Attendance Uploaded")));
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      top: cHeight * 0.01,
      bottom: cHeight * 0.01,
    );
    galleryBloc.fetchAllGallery(
      widget.userToken,
      context,
    );

    imageCarousel(List<ImageUrl> images) {
      List<NetworkImage> imagesList = [];
      for (int i = 0; i < images.length; i++) {
        imagesList.add(NetworkImage(images[i].imageLink));
      }
      return Container(
        height: cHeight * 0.3,
        width: cWidth,
        child: Carousel(
          indicatorBgPadding: 8.0,
          showIndicator: false,
          dotSize: cHeight * 0.005,
          autoplay: false,
          images: imagesList,
          onImageChange: (pre, next) {
            imageIndex = next;
            print(imageIndex);
          },
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: Text("Gallery"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              downloadFile();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: cHeight * 0.05,
                ),
                child: imageCarousel(widget.galleryData.imageUrl),
              ),
            ],
          ),
          Center(
            child: downloading
                ? Container(
                    height: 120.0,
                    width: 200.0,
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Downloading Image: $progressString",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Offstage(),
          ),
        ],
      ),
    );
  }
}
