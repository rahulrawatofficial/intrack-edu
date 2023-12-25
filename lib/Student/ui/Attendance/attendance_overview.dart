import 'dart:async';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:intrack/Student/blocs/attendance_overview_bloc.dart';
import 'package:intrack/Student/models/attendance_overview_model.dart';
// import 'package:lexin/functions/error.dart';

import 'package:shimmer/shimmer.dart';

double cWidth;
double cHeight;
var r;
bool display = false;

class OverView extends StatefulWidget {
  final String userToken;
  final String studentId;
  OverView({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  DateTime _selectedDate = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  String displayMonth;

  DateTime _selectedDate1 = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  // use DateTime.now() istead of DateTime(2019,01,01)
  String displayMonth1 = "Jan";

  DateTime _selectedDate2 = new DateTime.now();
  String displayMonth2 = "Jan";

  void _launchStartDate() async {
    display = false;
    _selectedDate = _selectedDate1;
    displayMonth1 = await selectDateFromPicker();
    setState(() {
      _selectedDate1 = _selectedDate;
    });
  }

  void _launchEndDate() async {
    display = true;
    _selectedDate = _selectedDate2;
    displayMonth2 = await selectDateFromPicker();
    setState(() {
      _selectedDate2 = _selectedDate;
    });
  }

  Future<String> selectDateFromPicker() async {
    DateTime _date = DateTime.now();
    DateTime d = new DateTime(
        1960); // For Start day of Calender change we used if condition
    if (display) {
      d = new DateTime(
          _selectedDate1.year, _selectedDate1.month, _selectedDate1.day);
    }

    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: d,
      lastDate: _date,
    );

    if (selected != null) {
      // var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      // var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      _selectedDate = selected;
      // selectedWeeksDays =
      //     Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
      //         .toList();
      // selectedMonthsDays = Utils.daysInMonth(selected);
      displayMonth = Utils.formatMonth(selected);
    }
    print("date: ${DateFormat.MMM().format(_selectedDate)}");
    return displayMonth;
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }

    EdgeInsets _pad = EdgeInsets.only(
        top: cHeight * 0.018,
        left: cWidth * 0.025,
        right: cWidth * 0.025,
        bottom: cHeight * 0.015);
    attendanceOverviewBloc.fetchAllAttendance(context, widget.userToken,
        widget.studentId, _selectedDate1.toString(), _selectedDate2.toString());
    return Container(
      padding: _pad,
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: _launchStartDate,
                    child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: cHeight * 0.04, bottom: cHeight * 0.04),
                          child: new Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: cWidth * 0.04, right: cWidth * 0.02),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: cWidth * 0.09,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Start date',
                                    style: new TextStyle(
                                      fontSize: cWidth * 0.032,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${_selectedDate1.day} ${DateFormat.MMM().format(_selectedDate1)} ${_selectedDate2.year}',
                                    style: new TextStyle(
                                      fontSize: cWidth * 0.043,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                        // leading: Icon(
                        //   Icons.calendar_today,
                        //   color: Colors.blue,
                        //   size: cWidth * 0.09,
                        // ),
                        // title: new Text(
                        //   'End date',
                        //   style: new TextStyle(
                        //     fontSize: cWidth * 0.032,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        // subtitle: new Text(
                        //   '${_selectedDate2.day} ${DateFormat.MMM().format(_selectedDate2)} ${_selectedDate2.year}',
                        //   style: new TextStyle(
                        //     fontSize: cWidth * 0.043,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // onTap: () {
                        //   _launchEndDate();
                        // },
                        // isThreeLine: true,
                        ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _launchEndDate,
                    child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: cHeight * 0.04, bottom: cHeight * 0.04),
                          child: new Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: cWidth * 0.04, right: cWidth * 0.02),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: cWidth * 0.09,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'End date',
                                    style: new TextStyle(
                                      fontSize: cWidth * 0.032,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${_selectedDate2.day} ${DateFormat.MMM().format(_selectedDate2)} ${_selectedDate2.year}',
                                    style: new TextStyle(
                                      fontSize: cWidth * 0.043,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                        // leading: Icon(
                        //   Icons.calendar_today,
                        //   color: Colors.blue,
                        //   size: cWidth * 0.09,
                        // ),
                        // title: new Text(
                        //   'End date',
                        //   style: new TextStyle(
                        //     fontSize: cWidth * 0.032,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        // subtitle: new Text(
                        //   '${_selectedDate2.day} ${DateFormat.MMM().format(_selectedDate2)} ${_selectedDate2.year}',
                        //   style: new TextStyle(
                        //     fontSize: cWidth * 0.043,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // onTap: () {
                        //   _launchEndDate();
                        // },
                        // isThreeLine: true,
                        ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            // color: Colors.green,
            child: Padding(
              padding:
                  EdgeInsets.only(top: cHeight * 0.025, bottom: cHeight * 0.04),
              child: StreamBuilder(
                stream: attendanceOverviewBloc.allAttendance,
                builder:
                    (context, AsyncSnapshot<AttendanceOverviewModel> snapshot) {
                  print(snapshot);
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: days(
                                "Total",
                                snapshot.data.data == null
                                    ? "!"
                                    : snapshot.data.data.stats.totalWorkingdays
                                        .toString(),
                                Colors.lightBlue,
                              ),
                            ),
                            Expanded(
                              child: days(
                                  "Present",
                                  snapshot.data.data == null
                                      ? "!"
                                      : snapshot.data.data.stats.presentDays
                                          .toString(),
                                  Colors.green),
                            ),
                            Expanded(
                              child: days(
                                "Percentage",
                                snapshot.data.data == null
                                    ? "!"
                                    : snapshot.data.data.stats.presentPercentage
                                        .toString(),
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        snapshot.data.data.stats.totalWorkingdays == 0
                            ? Offstage()
                            : Padding(
                                padding: EdgeInsets.only(top: cHeight * 0.03),
                                child: Card(
                                  elevation: 1.0,
                                  // color: Colors.white,
                                  child: new SizedBox(
                                    height: cHeight * 0.35,
                                    width: cWidth * 0.7,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: cHeight * 0.02,
                                          left: cWidth * 0.02,
                                          right: cWidth * 0.02),
                                      child: new Column(
                                        children: <Widget>[
                                          Container(
                                            height: cHeight * 0.24,
                                            width: cWidth * 0.7,
                                            child: Image(
                                              image: double.parse(snapshot
                                                          .data
                                                          .data
                                                          .stats
                                                          .presentPercentage) >
                                                      80.0
                                                  ? AssetImage(
                                                      "assets/icon/goldMedal.jpeg",
                                                    )
                                                  : AssetImage(
                                                      "assets/icon/needsimprovement.jpg",
                                                    ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: double.parse(snapshot
                                                        .data
                                                        .data
                                                        .stats
                                                        .presentPercentage) >
                                                    80.0
                                                ? Text(
                                                    'You have Performed Well !\n Keep it up.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        // color: Color(0xFF03DAC6),
                                                        ),
                                                  )
                                                : Text(
                                                    'Your attendance is low\n Be Regular!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        // color: Color(0xFF03DAC6),
                                                        ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: new Card(
          //     elevation: 1.0,
          //     // color: ,
          //     child: SizedBox(
          //       height: cHeight * 0.09,
          //       width: cWidth * 0.96,
          //       child: Padding(
          //         padding: EdgeInsets.only(left: cWidth * 0.05),
          //         child: new Row(
          //           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: <Widget>[
          //             new Icon(
          //               Icons.thumb_up,
          //               color: Colors.blue,
          //             ),
          //             Flexible(
          //                 child: Padding(
          //               padding: EdgeInsets.only(left: cWidth * 0.05),
          //               child: Text(
          //                 'You are here to learn',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                     // color: Color(0xFF018786),
          //                     fontSize: 15.0),
          //               ),
          //             )),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget shimmerCard() {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Card(
          child: Text(
            'Waiting...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget days(String type, String data, Color color) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
        child: new ListTile(
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: new Text(
              data,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: cWidth * 0.06,
              ),
            ),
          )),
          subtitle: Center(
            child: new Text(
              type,
              style: TextStyle(fontSize: cWidth * 0.035),
            ),
          ),
        ),
      ),
    );
  }
}
