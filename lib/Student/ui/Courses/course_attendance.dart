import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intrack/Resources/http_requests.dart';

import 'package:intrack/Student/blocs/attendance_calender_bloc.dart';
import 'package:intrack/Student/models/course_attendance_modelS.dart';

class CourseAttendance extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String classId;
  CourseAttendance({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
  }) : super(key: key);

  _CourseAttendanceState createState() => _CourseAttendanceState();
}

class _CourseAttendanceState extends State<CourseAttendance> {
  double cWidth;
  double cHeight;

  List courseName = [];
  List startTime = [];
  List endTime = [];
  var len = 0;
  List<bool> myListPresent = new List(367);
  List<String> myListDate = new List(367);
  Map<DateTime, bool> attendance;
  static Widget _presentIcon(String day) => Container(
        // height: 100.0,
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
  static Widget _absentIcon(String day) => Container(
        // height: 100.0,
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;

  Future<CourseAttendanceModelS> getCourseAttendance() async {
    var param = {
      "classId": widget.classId,
      "studentId": widget.studentId,
    };
    final response = await ApiBase().get(
        context, "/v1/getStudentCourseAttendance", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return courseAttendanceModelSFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.53,
      width: cWidth,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.blue[200],
      selectedDayBorderColor: Colors.grey[600],
      selectedDayButtonColor: Colors.grey[400],
      thisMonthDayBorderColor: Colors.grey,
      markedDatesMap: _markedDateMap,
      onDayPressed: (day, e) {
        setState(() {
          courseName.clear();
          startTime.clear();
          endTime.clear();
        });
      },
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
          null, // null for not showing hidden events indicator

      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );
    attendanceCalenderBloc.fetchAllAttendance(
      context,
      widget.userToken,
      widget.studentId,
    );
    print("####${widget.studentId}#");
    var date = new DateTime.now();
    var lastDay = Utils.lastDayOfMonth(date);
    print("LastDay: ${lastDay.day}");

    return Column(
      children: <Widget>[
        Container(
          child: FutureBuilder(
            future: getCourseAttendance(),
            builder: (context, AsyncSnapshot<CourseAttendanceModelS> snapshot) {
              if (snapshot.hasData) {
                len = snapshot.data.data.length;

                List<DateTime> dates = new List(len);

                for (int i = 0; i < len; i++) {
                  myListPresent[i] = true;
                  myListDate[i] = snapshot.data.data[i].date.toString();
                }
                // print("Attendance $attendance");

                for (int i = 0; i < len; i++)
                  dates[i] = DateTime.parse(myListDate[i]);

                for (int i = 0; i < len; i++) {
                  if (myListPresent[i] == true) {
                    _markedDateMap.add(
                      dates[i],
                      new Event(
                        date: dates[i],
                        title: 'Event 5',
                        icon: GestureDetector(
                          onTap: () {
                            print("Present");
                            setState(() {
                              courseName.clear();
                              startTime.clear();
                              endTime.clear();
                              for (int j = 0;
                                  j <
                                      snapshot.data.data[i].studentAttendance
                                          .length;
                                  j++) {
                                courseName.add(snapshot.data.data[i]
                                    .studentAttendance[j].courseId.courseName);
                                startTime.add(snapshot.data.data[i]
                                    .studentAttendance[j].startTime);
                                endTime.add(snapshot
                                    .data.data[i].studentAttendance[j].endTime);
                              }
                            });
                          },
                          child: _presentIcon(
                            dates[i].day.toString(),
                          ),
                        ),
                      ),
                    );
                  } else {
                    _markedDateMap.add(
                      dates[i],
                      new Event(
                        date: dates[i],
                        title: 'Event 5',
                        icon: _absentIcon(
                          dates[i].day.toString(),
                        ),
                      ),
                    );
                  }
                }

                return _calendarCarouselNoHeader;
              }
              return Container(
                height: cHeight * 0.54,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
        Column(
          children: List.generate(courseName.length, (index) {
            return Container(
              child: Column(
                children: <Widget>[
                  courseName.length > 0
                      ? Padding(
                          padding: EdgeInsets.only(top: cHeight * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Course Name - ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${courseName[index]}"),
                            ],
                          ),
                        )
                      : Offstage(),
                  startTime[index] != null
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: cWidth * 0.03, top: cHeight * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Start Time - ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text("${startTime[index]}"),
                            ],
                          ),
                        )
                      : Offstage(),
                  endTime[index] != null
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: cWidth * 0.03, top: cHeight * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "End Time - ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Text("${endTime[index]}"),
                            ],
                          ),
                        )
                      : Offstage(),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// class CallCalender extends StatefulWidget {
//   final String userToken;
//   final String studentId;
//   final String classId;
//   CallCalender({
//     Key key,
//     this.userToken,
//     this.studentId,
//     this.classId,
//   }) : super(key: key);
//   _CallCalenderState createState() => _CallCalenderState();
// }

// class _CallCalenderState extends State<CallCalender> {

//   @override
//   Widget build(BuildContext context) {

//     return FutureBuilder(
//       future: getCourseAttendance(),
//       builder: (context, AsyncSnapshot<CourseAttendanceModelS> snapshot) {
//         if (snapshot.hasData) {
//           len = snapshot.data.data.length;

//           List<DateTime> dates = new List(len);

//           for (int i = 0; i < len; i++) {
//             myListPresent[i] = true;
//             myListDate[i] = snapshot.data.data[i].date.toString();
//           }
//           // print("Attendance $attendance");

//           for (int i = 0; i < len; i++)
//             dates[i] = DateTime.parse(myListDate[i]);

//           for (int i = 0; i < len; i++) {
//             if (myListPresent[i] == true) {
//               _markedDateMap.add(
//                 dates[i],
//                 new Event(
//                   date: dates[i],
//                   title: 'Event 5',
//                   icon: GestureDetector(
//                     onTap: () {
//                       print("Present");
//                       setState(() {
//                         courseName= snapshot.data.data[i].studentAttendance[0].courseId.courseName;
//                       });
//                     },
//                     child: _presentIcon(
//                       dates[i].day.toString(),
//                     ),
//                   ),
//                 ),
//               );
//             } else {
//               _markedDateMap.add(
//                 dates[i],
//                 new Event(
//                   date: dates[i],
//                   title: 'Event 5',
//                   icon: _absentIcon(
//                     dates[i].day.toString(),
//                   ),
//                 ),
//               );
//             }
//           }

//           return _calendarCarouselNoHeader;
//         }
//         return Container(
//           height: cHeight * 0.54,
//           child: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }
// }
