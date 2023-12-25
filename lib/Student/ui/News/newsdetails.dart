import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/get_particular_news_bloc.dart';
import 'package:intrack/Student/models/get_particular_news_model.dart';
import 'package:intrack/Student/ui/News/news_imageview.dart';
import 'package:carousel_pro/carousel_pro.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({Key key, this.index, this.newsId, this.userToken, this.userId})
      : super(key: key);
  final int index;
  final String userToken;
  final String newsId;
  final String userId;
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  double cHeight;
  double cWidth;
  var likes = 0;
  bool pressButton;

  // int addLike() {
  //   setState(() {
  //     likes++;
  //   });
  //   print(likes);
  //   return likes;
  // }

  // int subLike() {
  //   setState(() {
  //     likes--;
  //   });
  //   print(likes);
  //   return likes;
  // }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var c = cHeight;
      cHeight = cWidth;
      cWidth = c;
    }
    particularNewsBloc.fetchAllParticularNews(
        widget.userToken, context, widget.newsId.toString());
    imageCarousel(List<NewsImageUrl> images) {
      List<NetworkImage> imagesList = [];
      for (int i = 0; i < images.length; i++) {
        imagesList.add(NetworkImage(images[i].imageUrl));
      }
      return Container(
        height: cHeight * 0.3,
        width: cWidth,
        child: Carousel(
          indicatorBgPadding: 8.0,
          // showIndicator: false,
          dotSize: cHeight * 0.005,
          autoplay: false,
          images: imagesList,
        ),
      );
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text("News Details"),
      ),
      body: StreamBuilder(
          stream: particularNewsBloc.allParticularNews,
          builder: (context, AsyncSnapshot<ParticularNewsModel> snapshot) {
            if (snapshot.hasData) {
              //print(snapshot.data);
              return ListView(
                children: <Widget>[
                  imageCarousel(snapshot.data.data.newsImageUrl),
                  Padding(
                    padding: EdgeInsets.only(
                        left: cWidth * 0.05,
                        right: cWidth * 0.05,
                        top: cHeight * 0.02),
                    child: Container(
                      width: cWidth * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data.data.title,
                            style: TextStyle(
                              fontSize: cHeight * 0.03,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: cHeight * 0.02),
                            child: Text(
                              snapshot.data.data.description,
                              style: TextStyle(
                                fontSize: cHeight * 0.02,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
