import 'package:flutter/material.dart';
import 'package:intrack/Resources/http_requests.dart';
import 'package:intrack/Student/models/timetable_model.dart';

class TimeTable extends StatefulWidget {
  final String userToken;
  final String studentId;
  TimeTable({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Future<TimeTableModel> getTimeTable() async {
    var param = {"studentId": widget.studentId};
    final response = await ApiBase()
        .get(context, "/v1/studentViewTimeTable", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return timeTableModelFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Timetable"),
        ),
        body: FutureBuilder(
            future: getTimeTable(),
            builder: (context, AsyncSnapshot<TimeTableModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data.schedule.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.data.schedule.length,
                      itemBuilder: (context, index1) {
                        return Container(
                            color: Colors.transparent,
                            child: ExpansionTile(
                              title: Text(
                                "${snapshot.data.data.schedule[index1].day}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: List.generate(
                                snapshot
                                    .data.data.schedule[index1].lectures.length,
                                (index) {
                                  return Column(
                                    children: <Widget>[
                                      index == 0
                                          ? ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    " Period",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Time In",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Offstage(),
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                " ${(index + 1)}. ${snapshot.data.data.schedule[index1].lectures[index].subjectName}"),
                                            Text(
                                                " ${snapshot.data.data.schedule[index1].lectures[index].timeIn}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
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
