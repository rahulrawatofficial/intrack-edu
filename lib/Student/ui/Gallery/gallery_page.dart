import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/gallery_bloc.dart';
import 'package:intrack/Student/models/gallery_model.dart';
import 'package:intrack/Student/ui/Gallery/gallery_detail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GalleryPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  GalleryPage({Key key, this.userToken, this.studentId}) : super(key: key);
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  double cHeight;
  double cWidth;

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
          // showIndicator: false,
          autoplayDuration: Duration(
            seconds: 5,
          ),
          dotSize: cHeight * 0.005,
          autoplay: true,
          images: imagesList,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: StreamBuilder(
          stream: galleryBloc.allGallery,
          builder: (context, AsyncSnapshot<GalleryModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // print(
                        //     "${snapshot.data.data[index].youTubeLinkUrl[1].youTubeLink}");
                        print("yo");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GalleryDetail(
                              userToken: widget.userToken,
                              galleryData: snapshot.data.data[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            snapshot.data.data[index].imageUrl.length > 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: cWidth * 0.03,
                                      top: cHeight * 0.01,
                                      // right: cWidth * 0.03,
                                    ),
                                    child: imageCarousel(
                                        snapshot.data.data[index].imageUrl),
                                    // child: Text(
                                    //   snapshot.data.data[index].id,
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: cHeight * 0.027),
                                    // ),
                                  )
                                : Offstage(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: cHeight * 0.025,
                                    left: cWidth * 0.03,
                                    // right: cWidth * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: cWidth * 0.8,
                                        child: Text(
                                          snapshot.data.data[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: cHeight * 0.027),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: cHeight * 0.01,
                                          bottom: cHeight * 0.01,
                                        ),
                                        child: Text(
                                          "${snapshot.data.data[index].created.toString().substring(0, 10)}, ${snapshot.data.data[index].created.toString().substring(12, 16)}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: _pad,
                                //   child: CircleAvatar(
                                //     radius: cHeight * 0.005,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No Data Found"),
                );
              }
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
