import 'package:flutter/material.dart';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/resources/reminder/createReminderApi.dart';
import 'package:intrack/Teacher/blocs/previous_attendance_bloc.dart';
import 'package:intrack/Teacher/models/previous_attendance_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousAttendance extends StatefulWidget {
  final String userToken;
  final String sectionId;
  final classData;
  PreviousAttendance({
    Key key,
    this.userToken,
    this.sectionId,
    this.classData,
  }) : super(key: key);
  @override
  _PreviousAttendanceState createState() => _PreviousAttendanceState();
}

class _PreviousAttendanceState extends State<PreviousAttendance> {
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
    previousAttendanceBloc.fetchAllAttendance(widget.userToken,
        widget.sectionId, _selectedDate.toString().substring(0, 10), context);
    return StreamBuilder(
        stream: previousAttendanceBloc.allPreviousAttendance,
        builder: (context, AsyncSnapshot<PreviousAttendanceModel> snapshot) {
          return Column(
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                        itemCount: snapshot.data.data.length > 0
                            ? snapshot.data.data[0].students.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${index + 1}.",
                                      style: TextStyle(
                                        fontSize: cHeight * 0.02,
                                      ),
                                    ),
                                    Container(
                                      width: cWidth * 0.7,
                                      child: Row(
                                        children: <Widget>[
                                          snapshot
                                                      .data
                                                      .data[0]
                                                      .students[index]
                                                      .studentId
                                                      .profilePicUrl !=
                                                  null
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot
                                                          .data
                                                          .data[0]
                                                          .students[index]
                                                          .studentId
                                                          .profilePicUrl),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: cWidth * 0.03),
                                            child: Text(
                                              snapshot
                                                  .data
                                                  .data[0]
                                                  .students[index]
                                                  .studentId
                                                  .name,
                                              style: TextStyle(
                                                fontSize: cHeight * 0.02,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: snapshot.data.data[0]
                                          .students[index].isPresent,
                                      onChanged: (_) {},
                                      activeColor: Color(0xFFFF6144),
                                    )
                                  ],
                                ),
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
                  // _uploadAttendance();
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
