import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/blocs/EventAndHoliday/school_event_bloc.dart';
import 'package:intrack/Student/blocs/EventAndHoliday/school_holiday_bloc.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_event_model.dart';
import 'package:intrack/Student/models/EventAndHolidays/school_holidays_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolHolidayPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  SchoolHolidayPage({Key key, this.userToken, this.studentId})
      : super(key: key);
  @override
  _SchoolHolidayPageState createState() => _SchoolHolidayPageState();
}

class _SchoolHolidayPageState extends State<SchoolHolidayPage> {
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
          if (snapshot.data.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   border: Border(
                      //     left: BorderSide(
                      //       width: 4,
                      //       color: Colors.orange[300],
                      //     ),
                      //   ),
                      // ),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                color: Colors.blueGrey[400],
                                height: cHeight * 0.03,
                                width: cWidth * 0.2,
                                child: Center(
                                  child: Text(
                                    DateFormat.MMMM().format(
                                      DateTime.parse(
                                        snapshot.data.data[index].dateOfHoliday
                                            .toString(),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: cHeight * 0.018,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[200],
                                height: cHeight * 0.07,
                                width: cWidth * 0.2,
                                child: Center(
                                  child: Text(
                                    DateFormat.d().format(
                                      DateTime.parse(
                                        snapshot.data.data[index].dateOfHoliday
                                            .toString(),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: cHeight * 0.035,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: cWidth * 0.03,
                                  top: cHeight * 0.01,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.data[index].occasion,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: cHeight * 0.023),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: cHeight * 0.015,
                                        left: cWidth * 0.03,
                                        right: cWidth * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: cWidth * 0.6,
                                          child: Text(
                                            DateFormat.EEEE().format(
                                              DateTime.parse(
                                                snapshot.data.data[index]
                                                    .dateOfHoliday
                                                    .toString(),
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: cHeight * 0.021,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("No Data Found"),
            );
          }
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
