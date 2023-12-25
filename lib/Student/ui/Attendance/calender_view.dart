import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:intrack/Student/blocs/attendance_calender_bloc.dart';
import 'package:intrack/Student/models/attendance_calender_model.dart';

double cWidth;
double cHeight;

class CalenderView extends StatefulWidget {
  final String userToken;
  final String studentId;
  CalenderView({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);

  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          child: CallCalender(
            userToken: widget.userToken,
            studentId: widget.studentId,
          ),
        ),
        new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.green[400],
            radius: cHeight * 0.025,
          ),
          title: new Text(
            'Present',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.red[400],
            radius: cHeight * 0.025,
          ),
          title: new Text(
            'Absent',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class CallCalender extends StatefulWidget {
  final String userToken;
  final String studentId;
  CallCalender({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  _CallCalenderState createState() => _CallCalenderState();
}

class _CallCalenderState extends State<CallCalender> {
  var url = "http://139.59.58.160:8001/v1/studentAttendance";
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.64,
      width: cWidth,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.blue[200],
      selectedDayBorderColor: Colors.grey[600],
      selectedDayButtonColor: Colors.grey[400],
      thisMonthDayBorderColor: Colors.grey,
      markedDatesMap: _markedDateMap,
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
    return StreamBuilder(
      stream: attendanceCalenderBloc.allAttendance,
      builder: (context, AsyncSnapshot<AttendanceCalenderModel> snapshot) {
        if (snapshot.hasData) {
          len = snapshot.data.data.length;

          List<DateTime> dates = new List(len);

          for (int i = 0; i < len; i++) {
            myListPresent[i] = snapshot.data.data[i].students[0].isPresent;
            myListDate[i] = snapshot.data.data[i].date;
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
                  icon: _presentIcon(
                    dates[i].day.toString(),
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
    );
  }
}
