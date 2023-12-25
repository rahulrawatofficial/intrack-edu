import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/social_media_bloc.dart';
import 'package:intrack/Student/models/social_media_model.dart';
import 'package:intrack/Student/models/timetable_model.dart';
import 'package:intrack/Student/blocs/timetable_bloc.dart';
import 'package:intrack/Student/ui/EventAndHolidays/school_event_page.dart';
import 'package:intrack/Student/ui/EventAndHolidays/school_holiday_page.dart';
import 'package:intrack/Student/ui/SocialMedia/facebook_page.dart';

class EventHolidayPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  EventHolidayPage({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  @override
  _EventHolidayPageState createState() => _EventHolidayPageState();
}

// _InternalLinkedHashMap<String, dynamic> jk;
TimeTableModel timeTable;

class _EventHolidayPageState extends State<EventHolidayPage> {
  // final String url = "http://139.59.58.160:8001/v1/studentViewTimeTable";

  @override
  void initState() {
    super.initState();
    print(widget.studentId);
    //print(timeTable.data.id);
    //this._postConnect();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Events and Holidays"),
          bottom: TabBar(
            // isScrollable: true,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: "Events",
              ),
              Tab(text: "Holidays")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SchoolEventPage(
              userToken: widget.userToken,
            ),
            SchoolHolidayPage(
              userToken: widget.userToken,
            ),
          ],
        ),
      ),
    );
  }
}
