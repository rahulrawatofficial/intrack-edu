import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Resources/http_requests.dart';
import 'package:intrack/Student/models/course_content_model.dart';
import 'package:intrack/Teacher/ui/Courses/teacher_calling_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class TCourseContentDetail extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String studentName;
  final String classId;
  final String courseId;
  final String courseName;
  TCourseContentDetail({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
    this.courseId,
    this.courseName,
    this.studentName,
  }) : super(key: key);
  @override
  _TCourseContentDetailState createState() => _TCourseContentDetailState();
}

class _TCourseContentDetailState extends State<TCourseContentDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool downloading = false;
  var progressString = "";
  var dir;

  Future<CourseContentModel> getCourseContentDetail() async {
    var param = {
      "courseId": widget.courseId,
    };
    final response = await ApiBase()
        .get(context, "/v1/getParticularCourseDetail", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return courseContentModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future createSession(String chapterId) async {
    var body = {
      "courseId": widget.courseId,
      "classId": widget.classId,
      "chapterId": chapterId,
    };
    final response = await ApiBase()
        .post(context, "/v1/createLiveClasses", null, body, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      var d = json.decode(response.body);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TeacherCallingScreen(
                serverUrl: d["data"]["link"],
                userToken: widget.userToken,
                studentName: widget.studentName,
                liveClassesId: d["data"]["_id"],
              )));
      // return courseContentModelFromJson(response.body);
    } else {
      // return null;
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
  void initState() {
    print("classId ${widget.classId}");
    print("studentId ${widget.studentId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("${widget.courseName}"),
        ),
        body: FutureBuilder(
            future: getCourseContentDetail(),
            builder: (context, AsyncSnapshot<CourseContentModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.data[0].chapters.length,
                      itemBuilder: (context, index) {
                        return Container(
                            color: Colors.transparent,
                            child: ExpansionTile(
                              title: Text(
                                "${snapshot.data.data[0].chapters[index].chapterName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    print(snapshot
                                        .data.data[0].chapters[index].id);
                                    // if (snapshot.data.data[0].chapters[index]
                                    //         .pdfFileUrl !=
                                    //     null) {
                                    createSession(snapshot
                                        .data.data[0].chapters[index].id);
                                    // } else {
                                    //   showDialogSingleButton(context, "",
                                    //       "No live session found", "Ok");
                                    // }
                                  },
                                  leading: Icon(Icons.videocam),
                                  title: Text("Start session"),
                                ),
                                ListTile(
                                  onTap: () {
                                    if (snapshot.data.data[0].chapters[index]
                                            .pdfFileUrl !=
                                        null) {
                                      downloadFile(snapshot.data.data[0]
                                          .chapters[index].pdfFileUrl);
                                    } else {
                                      showDialogSingleButton(
                                          context, "", "No pdf found", "Ok");
                                    }
                                  },
                                  leading: Icon(Icons.picture_as_pdf),
                                  title: Text("Open Pdf"),
                                )
                              ],
                              // children: List.generate(
                              //   snapshot
                              //       .data.data[index1]..length,
                              //   (index) {
                              //     return Column(
                              //       children: <Widget>[
                              //         index == 0
                              //             ? ListTile(
                              //                 title: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: <Widget>[
                              //                     Text(
                              //                       " Period",
                              //                       style: TextStyle(
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                     Text(
                              //                       "Time In",
                              //                       style: TextStyle(
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               )
                              //             : Offstage(),
                              //         ListTile(
                              //           title: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: <Widget>[
                              //               Text(
                              //                   " ${(index + 1)}. ${snapshot.data.data.schedule[index1].lectures[index].subjectName}"),
                              //               Text(
                              //                   " ${snapshot.data.data.schedule[index1].lectures[index].timeIn}"),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // ),
                            ));
                      });
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
