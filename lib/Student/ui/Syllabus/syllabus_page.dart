import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/get_student_syllabus_list_bloc.dart';
import 'package:intrack/Student/models/student_syllabus_list_model.dart';

import 'package:intrack/web_view_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SyllabusPage extends StatefulWidget {
  final String userToken;
  final String sectionId;
  SyllabusPage({
    Key key,
    this.userToken,
    this.sectionId,
  }) : super(key: key);
  @override
  _SyllabusPageState createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double cHeight;
  double cWidth;

  TextEditingController controller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // final imgUrl = "http://www.edo.ca/downloads/project-management.pdf";
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

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
    getStudentSyllabusListBloc.fetchAllSyllabusList(
        widget.userToken, widget.sectionId, context);
    // previousHomeworkBloc.fetchAllHomework(widget.userToken, widget.sectionId,
    //     _selectedDate.toString().substring(0, 10), context);
    return StreamBuilder(
        stream: getStudentSyllabusListBloc.allStudentSyllabusList,
        builder: (context, AsyncSnapshot<StudentSyllabusListModel> snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Syllabus"),
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
                    : Column(
                        children: <Widget>[
                          !snapshot.hasData
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : snapshot.data.data.length > 0
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data.data[index]
                                                          .title,
                                                      style: TextStyle(
                                                        fontSize:
                                                            cHeight * 0.025,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    snapshot.data.data[index]
                                                                .documentUrl !=
                                                            null
                                                        ? IconButton(
                                                            icon: Icon(Icons
                                                                .attach_file),
                                                            onPressed: () {
                                                              snapshot
                                                                          .data
                                                                          .data[
                                                                              index]
                                                                          .fileType ==
                                                                      "other"
                                                                  ? downloadFile(snapshot
                                                                      .data
                                                                      .data[
                                                                          index]
                                                                      .documentUrl)
                                                                  : Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => WebViewScreen(
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
                                                    snapshot.data.data[index]
                                                        .description,
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
                                  : Center(
                                      child: Text("No Data Found"),
                                    ),
                        ],
                      ),
              ],
            ),
          );
        });
  }
}
