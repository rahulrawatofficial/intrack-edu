import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/get_news_bloc.dart';
import 'package:intrack/Student/models/get_news_model.dart';
import 'package:intrack/Student/ui/News/newsdetails.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class News extends StatefulWidget {
  final String userToken;
  final String userId;
  News({Key key, this.userToken, this.userId}) : super(key: key);
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  double cHeight;
  double cWidth;
  List<int> likes = List();
  List<bool> pressButton = List.filled(10000, false);
  var data;
  final String url = "https://api-dashboard.intrack.in/v1/updateLikes";

  int addLike(int index) {
    setState(() {
      likes[index]++;
    });
    print(likes);
    return likes[index];
  }

  int subLike(int index) {
    setState(() {
      likes[index]--;
    });
    print(likes);
    return likes[index];
  }

  Future _postLike(String newsId) async {
    Map body = {"newsId": newsId};

    print("body $body");
    print("jsonBody ${body.runtimeType}");
    //String jsonHomework = json.encode(body);
    //print("jsonBody ${jsonHomework.runtimeType}");
    final response = await http.put(
      Uri.encodeFull(url),
      body: body,
      headers: {
        "authorization": "Bearer " + widget.userToken,
      },
    );
    if (response.statusCode == 200) {
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
    }
    if (response.statusCode == 403) {
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
    }
  }

  Future<GetNewsModel> getNews() async {
    String path = "/v1/getNewsList";
    //Map<String, String> params = {'start': '1'};
    print("entered");
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + widget.userToken
      },
    );
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      setState(() {
        data = GetNewsModel.fromJson(json.decode(response.body));

        // print("data is : ${data.data[0].newsLikes.length}");
        for (int j = 0; j < data.data.length; j++) {
          for (int i = 0; i < data.data[j].newsLikes.length; i++) {
            if (widget.userId == data.data[j].newsLikes[i]) {
              pressButton[j] = true;
            }
          }
          likes.add(data.data[j].newsLikes.length);
        }
      });
      return GetNewsModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      // logOut();
      // return ShowError().tokenExpired(context, "Error", "Token Expired", "Ok");
    }
  }

  @override
  void initState() {
    print("user id is: ${widget.userId}");
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var c = cHeight;
      cHeight = cWidth;
      cWidth = c;
    }
    newsBloc.fetchAllNews(widget.userToken, context);
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.data.length > 0
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: cWidth * 0.04,
                    vertical: cHeight * 0.03,
                  ),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: data.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetails(
                                        index: index,
                                        userToken: widget.userToken,
                                        newsId: data.data[index].id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    // color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: data.data[index].newsImageUrl.length >
                                          0
                                      ? CachedNetworkImage(
                                          imageUrl: data.data[index]
                                              .newsImageUrl[0].imageUrl,
                                          // height: cHeight * 0.18,
                                          // width: cWidth * 0.37,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            "assets/imageplaceholder.png",
                                            // height: cHeight * 0.18,
                                            // width: cWidth * 0.37,
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/imageplaceholder.png",
                                            // height: cHeight * 0.18,
                                            // width: cWidth * 0.37,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/imageplaceholder.png",
                                          fit: BoxFit.cover,
                                        ),
                                  // child: Image(
                                  //   image: AssetImage(image[index % 5]),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ),
                            // data to be printed
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: cWidth * 0.26,
                                  child: Text(
                                    data.data[index].title,
                                    style: new TextStyle(
                                        fontSize: cWidth * 0.038,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      color: pressButton[index] == true
                                          ? Colors.red
                                          : Colors.grey,
                                      icon: Icon(Icons.favorite),
                                      onPressed: () {
                                        pressButton[index] != true
                                            ? pressButton[index] = true
                                            : pressButton[index] = false;
                                        pressButton[index] == true
                                            ? addLike(index)
                                            : subLike(index);
                                        print(pressButton[index]);
                                        _postLike(data.data[index].id);
                                      },
                                    ),
                                    Text(likes[index].toString()),
                                  ],
                                ),
                              ],
                            )

                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: cHieght * 0.01,
                            //   ),
                            //   child: Align(
                            //     child: new Text(
                            //       snapshot.data.data[index].title,
                            //       style: new TextStyle(
                            //           fontSize: cWidth * 0.04,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //     alignment: Alignment.topCenter,
                            //   ),
                            // ),

                            // till here
                          ],
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(2, index.isEven ? 4 : 3),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 16,
                  ),
                )
              : Center(
                  child: Text("No Data Found"),
                ),
      //  else
      //   return Center(
      //     child: CircularProgressIndicator(),
      //   );
    );
  }
}
