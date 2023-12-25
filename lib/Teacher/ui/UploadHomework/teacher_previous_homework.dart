import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/resources/reminder/createReminderApi.dart';
import 'package:intrack/Teacher/blocs/previous_homework_bloc.dart';
import 'package:intrack/Teacher/models/previous_homework_model.dart';
import 'package:intrack/Teacher/ui/UploadHomework/edit_homework.dart';
import 'package:intrack/web_view_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherPreviousHomework extends StatefulWidget {
  final String userToken;
  final String sectionId;
  final classData;
  final List subjects;
  TeacherPreviousHomework({
    Key key,
    this.userToken,
    this.sectionId,
    this.classData,
    this.subjects,
  }) : super(key: key);
  @override
  _TeacherPreviousHomeworkState createState() =>
      _TeacherPreviousHomeworkState();
}

class _TeacherPreviousHomeworkState extends State<TeacherPreviousHomework> {
  double cHeight;
  double cWidth;

  TextEditingController controller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDate = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  String displayDate;

  DateTime currentDate = DateTime.now();
  DateTime selected = DateTime.now();

  DateTime _selectedDate1 = DateTime.now();
  // use DateTime.now() istead of DateTime(2019,01,01)
  String displayMonth1 = Utils.fullDayFormat(DateTime.now());

  bool downloading = false;
  var progressString = "";
  var dir;

  Future<void> downloadFile(String imgUrl) async {
    print(imgUrl);
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
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Pdf Saved'),
    ));
    // scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text("Image Saved")));
  }

  void _launchStartDate() async {
    //display = false;

    _selectedDate = _selectedDate1;
    displayMonth1 = await selectDateFromPicker();
    setState(() {
      _selectedDate1 = _selectedDate;
    });
  }

  Future<String> selectDateFromPicker() async {
    DateTime _date = DateTime(3050);

    selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2019),
      lastDate: _date,
    );

    if (selected != null) {
      _selectedDate = selected;
      displayDate = Utils.fullDayFormat(selected);
      displayDate = DateFormat.MMMMEEEEd().format(_selectedDate);
      return displayDate;
    } else {
      print("***$displayDate***");
      return displayDate;
    }
    //print(displayMonth);
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
    previousHomeworkBloc.fetchAllHomework(widget.userToken, widget.sectionId,
        _selectedDate.toString().substring(0, 10), context);
    return StreamBuilder(
        stream: previousHomeworkBloc.allPreviousHomework,
        builder: (context, AsyncSnapshot<PreviousHomeworkModel> snapshot) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: _pad,
                              child: Text(
                                "Select Date",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF6144),
                                ),
                              ),
                            ),
                            Padding(
                              padding: _pad,
                              child: Container(
                                //color: Colors.lightBlue,
                                child: GestureDetector(
                                  onTap: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    _launchStartDate();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: cHeight * 0.02,
                                      bottom: cHeight * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: cWidth * 0.03,
                                          ),
                                          child: Icon(
                                            Icons.date_range,
                                            size: 30,
                                            color: Color(0xFFFF6144),
                                          ),
                                        ),
                                        Text(
                                          Utils.fullDayFormat(_selectedDate),
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        snapshot.hasData
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Container detailsContainer(
                                        EdgeInsetsGeometry _pad, int index) {
                                      return Container(
                                          //color: Colors.red,
                                          // height: cHieght * 0.15,
                                          width: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? cWidth * 0.45
                                              : cWidth * 1.8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    cWidth * 0.01,
                                                    cHeight * 0.001,
                                                    cWidth * 0.01,
                                                    cHeight * 0),
                                                child: new Text(
                                                  snapshot.data.data[index]
                                                      .homework.subjectName,
                                                  style: new TextStyle(
                                                      fontSize: cHeight * 0.023,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                                    snapshot.data.data[index]
                                                        .homework.problems,
                                                    style: new TextStyle(
                                                      fontSize: cHeight * 0.02,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ));
                                    }

                                    CircleAvatar subjectCircle(int index) {
                                      return CircleAvatar(
                                        child: new Text(
                                          snapshot.data.data[index].homework
                                              .subjectName
                                              .substring(0, 1),
                                          style: TextStyle(
                                              fontSize: cHeight * 0.045,
                                              color: Colors.white),
                                        ),
                                        radius: cWidth * 0.08,
                                        backgroundColor: Colors.orange[300],
                                      );
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        print(snapshot
                                            .data.data[index].homework.id);
                                        // MaterialPageRoute(
                                        //     builder: (context) => EditHomework(
                                        //           classData: widget.classData,
                                        //           homeworkId: snapshot
                                        //               .data.data[index].homework.id,
                                        //           subjects: widget.subjects,
                                        //           userToken: widget.userToken,
                                        //         ));
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EditHomework(
                                              classData: widget.classData,
                                              homeworkId:
                                                  snapshot.data.data[index].id,
                                              subjects: widget.subjects,
                                              userToken: widget.userToken,
                                              subjectName: snapshot
                                                  .data
                                                  .data[index]
                                                  .homework
                                                  .subjectName,
                                              description: snapshot
                                                  .data
                                                  .data[index]
                                                  .homework
                                                  .problems,
                                              subjectHomeworkId: snapshot
                                                  .data.data[index].homework.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: _pad,
                                              child: subjectCircle(index),
                                            ),
                                            Padding(
                                              padding: _pad,
                                              child:
                                                  detailsContainer(_pad, index),
                                            ),
                                            snapshot.data.data[index].homework
                                                        .documentUrl !=
                                                    null
                                                ? IconButton(
                                                    icon:
                                                        Icon(Icons.attach_file),
                                                    onPressed: () {
                                                      snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .homework
                                                                  .fileType ==
                                                              "other"
                                                          ? downloadFile(
                                                              snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .homework
                                                                  .documentUrl)
                                                          : Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          WebViewScreen(
                                                                            url:
                                                                                snapshot.data.data[index].homework.documentUrl,
                                                                            fileType:
                                                                                snapshot.data.data[index].homework.fileType,
                                                                          )));
                                                    },
                                                  )
                                                : Offstage()
                                          ],
                                        ),
                                      ),
                                    );
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

  void showDialogSingleButton(BuildContext context, String title,
      String message, String buttonLabel1, String buttonLabel2) {
//flutter define function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //return object of type dialoge
          return AlertDialog(
            title: new Text("$title \n"),
            content: new Text(message ?? "Empty"),
            actions: <Widget>[
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel2),
                onPressed: () {
                  // _uploadHomework();
                  Navigator.of(context).pop();
                  createReminder(
                    context,
                    widget.userToken,
                    "Add it",
                    controller.text,
                    selected.toString().substring(0, 10),
                  );
                  Navigator.of(context).pop(context);
                },
              ),
            ],
          );
        });
  }
}
