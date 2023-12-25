import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/EventAndHoliday/school_event_bloc.dart';
import 'package:intrack/Student/blocs/EventAndHoliday/school_holiday_bloc.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_event_model.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_holidays_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherHolidayPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  TeacherHolidayPage({Key key, this.userToken, this.studentId})
      : super(key: key);
  @override
  _TeacherHolidayPageState createState() => _TeacherHolidayPageState();
}

class _TeacherHolidayPageState extends State<TeacherHolidayPage> {
  double cHeight;
  double cWidth;

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
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      top: cHeight * 0.01,
      bottom: cHeight * 0.01,
    );
    schoolHolidayBloc.fetchAllSchoolHoliday(context, widget.userToken);

    return StreamBuilder(
      stream: schoolHolidayBloc.allSchoolHoliday,
      builder: (context, AsyncSnapshot<SchoolHolidayModel> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 4,
                          color: Color(0xFFFF6144),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: cWidth * 0.03,
                            top: cHeight * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                snapshot.data.data[index].occasion,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: cHeight * 0.027),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: cHeight * 0.025,
                                  left: cWidth * 0.03,
                                  right: cWidth * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: cWidth * 0.85,
                                    child: Text(
                                      snapshot.data.data[index].dateOfHoliday
                                          .toString()
                                          .substring(0, 10),
                                      style: TextStyle(
                                        fontSize: cHeight * 0.018,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: cHeight * 0.01,
                                      bottom: cHeight * 0.01,
                                    ),
                                    // child: Text(
                                    //   "${snapshot.data.data[index].notification.created.toString().substring(0, 10)}, ${snapshot.data.data[index].notification.created.toString().substring(12, 16)}",
                                    //   style: TextStyle(color: Colors.grey),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: _pad,
                            //   child: CircleAvatar(
                            //     radius: cHeight * 0.005,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
