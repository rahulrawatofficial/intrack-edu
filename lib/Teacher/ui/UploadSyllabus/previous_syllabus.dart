import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:intrack/Teacher/blocs/get_teacher_syllabus_list_bloc.dart';
import 'package:intrack/Teacher/models/teacher_syllabus_list_model.dart';
import 'package:intrack/web_view_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherPreviousSyllabus extends StatefulWidget {
  final String userToken;
  final String sectionId;
  TeacherPreviousSyllabus({
    Key key,
    this.userToken,
    this.sectionId,
  }) : super(key: key);
  @override
  _TeacherPreviousSyllabusState createState() =>
      _TeacherPreviousSyllabusState();
}

class _TeacherPreviousSyllabusState extends State<TeacherPreviousSyllabus> {
  double cHeight;
  double cWidth;

  TextEditingController controller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      dir = await getApplicationDocumentsDirectory();

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
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Pdf Saved'),
    ));
    // scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text("Image Saved")));
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
        left: cWidth * 0.05,
        right: cWidth * 0.05,
        top: cHeight * 0.01,
        bottom: cHeight * 0.01);
    getTeacherSyllabusListBloc.fetchAllSyllabusList(
        widget.userToken, widget.sectionId, context);
    // previousHomeworkBloc.fetchAllHomework(widget.userToken, widget.sectionId,
    //     _selectedDate.toString().substring(0, 10), context);
    return StreamBuilder(
        stream: getTeacherSyllabusListBloc.allTeacherSyllabusList,
        builder: (context, AsyncSnapshot<TeacherSyllabusListModel> snapshot) {
          return Stack(
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
                  : Column(
                      children: <Widget>[
                        snapshot.hasData
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return new Card(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.data[index].title,
                                                style: TextStyle(
                                                  fontSize: cHeight * 0.025,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              snapshot.data.data[index]
                                                          .documentUrl !=
                                                      null
                                                  ? IconButton(
                                                      icon: Icon(
                                                          Icons.attach_file),
                                                      onPressed: () {
                                                        snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .fileType ==
                                                                "other"
                                                            ? downloadFile(
                                                                snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .documentUrl)
                                                            : Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            WebViewScreen(
                                                                              url: snapshot.data.data[index].documentUrl,
                                                                              fileType: snapshot.data.data[index].fileType,
                                                                            )));
                                                      },
                                                    )
                                                  : Offstage(),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: cHeight * 0.01),
                                            child: Text(
                                              snapshot
                                                  .data.data[index].description,
                                              style: TextStyle(
                                                fontSize: cHeight * 0.02,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  },
                                ),
                              )
                            : snapshot.hasError
                                ? Text(snapshot.error.toString())
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ],
                    ),
            ],
          );
        });
  }
}
