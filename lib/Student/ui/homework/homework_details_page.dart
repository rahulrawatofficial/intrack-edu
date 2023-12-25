import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intl/intl.dart';
import 'package:intrack/pdf_view_screen.dart';
import 'package:intrack/web_view_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

class HomeworkDetails extends StatefulWidget {
  final HomeworkModel value;
  final int currentIndex;
  final date;
  HomeworkDetails({Key key, this.value, this.currentIndex, this.date})
      : super(key: key);
  @override
  _HomeworkDetailsState createState() => _HomeworkDetailsState();
}

class _HomeworkDetailsState extends State<HomeworkDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double cHeight;
  double cWidth;
  List data;
  var date;
  var month;
  var year;

  @override
  void initState() {
    super.initState();
    date = widget.date.toString().substring(8, 10);
    month = DateFormat.MMM().format(DateTime.parse(widget.date));
    year = DateFormat.y().format(DateTime.parse(widget.date));
  }

  bool downloading = false;
  var progressString = "";
  var dir;

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

  Future<File> createFileOfPdfUrl(String url) async {
    // final url =
    // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // final url = "https://pdfkit.org/docs/guide.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
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

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.fromLTRB(
      cWidth * 0.01,
      cHeight * 0.01,
      cWidth * 0.01,
      cHeight * 0.01,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("$date $month, $year"),
      ),
      body: Stack(
        children: <Widget>[
          downloading
              ? Center(
                  child: Container(
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
                            "Downloading File: $progressString",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : new ListView.builder(
                  itemCount: widget.value.data[widget.currentIndex].homework
                              .length ==
                          null
                      ? 0
                      : widget.value.data[widget.currentIndex].homework.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      child: new Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: _pad,
                            child: subjectCircle(index),
                          ),
                          Padding(
                            padding: _pad,
                            child: detailsContainer(_pad, index),
                          ),
                          widget.value.data[widget.currentIndex].homework[index]
                                      .documentUrl !=
                                  null
                              ? IconButton(
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () {
                                    widget.value.data[widget.currentIndex]
                                                .homework[index].fileType ==
                                            "other"
                                        ? downloadFile(widget
                                            .value
                                            .data[widget.currentIndex]
                                            .homework[index]
                                            .documentUrl)
                                        : Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewScreen(
                                                      url: widget
                                                          .value
                                                          .data[widget
                                                              .currentIndex]
                                                          .homework[index]
                                                          .documentUrl,
                                                      fileType: widget
                                                          .value
                                                          .data[widget
                                                              .currentIndex]
                                                          .homework[index]
                                                          .fileType,
                                                    )));
                                    // });
                                  },
                                )
                              : Offstage(),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Container detailsContainer(EdgeInsetsGeometry _pad, int index) {
    var homeworkProblem =
        widget.value.data[widget.currentIndex].homework[index].problems;
    var subjectName =
        widget.value.data[widget.currentIndex].homework[index].subjectName;
    return Container(
        //color: Colors.red,
        // height: cHieght * 0.15,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? cWidth * 0.6
            : cWidth * 1.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  cWidth * 0.01, cHeight * 0.001, cWidth * 0.01, cHeight * 0),
              child: new Text(
                subjectName,
                style: new TextStyle(
                    fontSize: cWidth * 0.05, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: cWidth * 0.025,
                right: cWidth * 0.01,
                top: cHeight * 0.01,
                bottom: cHeight * 0.01,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  homeworkProblem,
                  style: new TextStyle(fontSize: cWidth * 0.04),
                ),
              ),
            ),
          ],
        ));
  }

  CircleAvatar subjectCircle(int index) {
    return CircleAvatar(
      child: new Text(
        widget.value.data[widget.currentIndex].homework[index].subjectName
            .toString()
            .substring(0, 1),
        style: TextStyle(fontSize: cHeight * 0.045, color: Colors.white),
      ),
      radius: cWidth * 0.1,
      backgroundColor: Colors.grey[300],
    );
  }
}
