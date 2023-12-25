import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/get_events_bloc.dart';
import 'package:intrack/Student/blocs/notifications_bloc.dart';
import 'package:intrack/Student/models/event_list_model.dart';
import 'package:intrack/Student/models/notifications_model.dart';
import 'package:intrack/web_view_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeBoardPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  NoticeBoardPage({Key key, this.userToken, this.studentId}) : super(key: key);
  @override
  _NoticeBoardPageState createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double cHeight;
  double cWidth;
  bool downloading = false;
  var progressString = "";
  var dir;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> downloadFile(String imgUrl) async {
    Dio dio = Dio();
    dir = await getApplicationDocumentsDirectory();
    String p = imgUrl.split(".").last != "pdf"
        ? "${dir.path}/${imgUrl.split("/").last}.pdf"
        : "${dir.path}/${imgUrl.split("/").last}";
    print(p);
    try {
      // dir = await getApplicationDocumentsDirectory();

      await dio.download(imgUrl, p, onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

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
    OpenFile.open(p);
    print("Download completed");
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text("Pdf Saved")));
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
    eventsBloc.fetchAllEvents(context, widget.userToken, widget.studentId);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Notice Board"),
      ),
      body: StreamBuilder(
          stream: eventsBloc.allEvents,
          builder: (context, AsyncSnapshot<EventListModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data.data[index].event != null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 4,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: cWidth * 0.03,
                                    top: cHeight * 0.01,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.data[index].event.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: cHeight * 0.027),
                                      ),
                                      snapshot.data.data[index].event
                                                  .eventImageUrl !=
                                              null
                                          ? IconButton(
                                              icon: Icon(Icons.attach_file),
                                              onPressed: () {
                                                snapshot.data.data[index].event
                                                            .fileType ==
                                                        "other"
                                                    ? downloadFile(snapshot
                                                        .data
                                                        .data[index]
                                                        .event
                                                        .eventImageUrl)
                                                    : Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebViewScreen(
                                                                  url: snapshot
                                                                      .data
                                                                      .data[
                                                                          index]
                                                                      .event
                                                                      .eventImageUrl,
                                                                  fileType: snapshot
                                                                      .data
                                                                      .data[
                                                                          index]
                                                                      .event
                                                                      .fileType,
                                                                )));
                                              },
                                            )
                                          : Offstage(),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: cHeight * 0.025,
                                          left: cWidth * 0.03,
                                          right: cWidth * 0.03),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: cWidth * 0.85,
                                            child: Text(
                                              snapshot.data.data[index].event
                                                  .description,
                                              style: TextStyle(
                                                fontSize: cHeight * 0.018,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: cHeight * 0.01,
                                              bottom: cHeight * 0.01,
                                            ),
                                            // child: Text(
                                            //   "${snapshot.data.data[index].notification.created.toString().substring(0, 10)}, ${snapshot.data.data[index].notification.created.toString().substring(12, 16)}",
                                            //   style: TextStyle(color: Colors.grey),
                                            // ),
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
                        ),
                      );
                    } else {
                      return Offstage();
                    }
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
