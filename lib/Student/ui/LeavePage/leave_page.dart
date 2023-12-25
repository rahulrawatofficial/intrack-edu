import 'package:flutter/material.dart';
import 'package:intrack/Functions/error.dart';
import 'package:intrack/Student/resources/leaves/get_leaves_list.dart';
import 'package:intrack/Student/resources/reminder/getReminderListApi.dart';
import 'package:intrack/Student/ui/LeavePage/add_leave.dart';
import 'package:intrack/Student/ui/LeavePage/update_leave.dart';
import 'package:intrack/Student/ui/Reminders/addReminders.dart';
import 'package:intrack/Student/ui/Reminders/updateReminder.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LeavesPage extends StatefulWidget {
  final String userToken;
  final String studentId;

  final String classId;
  final String sectionId;
  LeavesPage({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _LeavesPageState createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  double cHeight, cWidth;
  var data;

  Future<void> getData() async {
    data = await getLeavesList(
      context,
      widget.userToken,
      widget.studentId,
    );
  }

  @override
  void initState() {
    print("class id is ${widget.classId}");
    print("sectionId id is ${widget.sectionId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.only(
        top: cHeight * 0.01, left: cWidth * 0.05, right: cWidth * 0.05);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF444B54),
        child: Icon(Icons.add),
        onPressed: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => AddLeave(
              userToken: widget.userToken,
              studentId: widget.studentId,
              classId: widget.classId,
              sectionId: widget.sectionId,
            ),
          );
          Navigator.of(context).push(route);
        },
      ),
      appBar: AppBar(
        title: Text("Leaves"),
      ),
      // backgroundColor: Colors.brown[50],
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) return errorCheck();
            if (data["data"].length > 0) {
              return ListView.builder(
                itemCount: data["data"].length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateLeave(
                          userToken: widget.userToken,
                          description: data["data"][index]["leaveDescription"],
                          firstDate: data["data"][index]["leaveDates"][0]
                              ["dateOfLeave"],
                          lastDate: data["data"][index]["leaveDates"]
                                  [data["data"][index]["leaveDates"].length - 1]
                              ["dateOfLeave"],
                          title: data["data"][index]["leaveTitle"],
                          leaveId: data["data"][index]["_id"],
                          classId: widget.classId,
                          sectionId: widget.sectionId,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: _pad,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3.0),
                                    topRight: Radius.circular(3.0)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _pad,
                                    child: Center(
                                      child: Text(
                                        data['data'][index]['leaveTitle'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: cHeight * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          cWidth * 0.05,
                                          cHeight * 0.02,
                                          cWidth * 0.05,
                                          cHeight * 0.02),
                                      child: Text(
                                        data['data'][index]['leaveDescription'],
                                        style: TextStyle(
                                          fontSize: cHeight * 0.025,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: cWidth * 0.05,
                                        right: cWidth * 0.05,
                                        bottom: cHeight * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data['data'][index]['status'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: data['data'][index]
                                                        ['status'] ==
                                                    "APPROVED"
                                                ? Colors.green
                                                : data['data'][index]
                                                            ['status'] ==
                                                        "REJECTED"
                                                    ? Colors.red
                                                    : Colors.yellow,
                                          ),
                                        ),
                                        Text(
                                            '${data['data'][index]['leaveDates'].length} day leave'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   child: Column(
                            //     children: <Widget>[
                            //       GestureDetector(
                            //         onTap: null,
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.only(
                            //                 bottomLeft: Radius.circular(3),
                            //                 bottomRight:
                            //                     Radius.circular(3)),
                            //             color: difference < 5
                            //                 ? Colors.red[400]
                            //                 : Colors.green[400],
                            //           ),
                            //           child: Padding(
                            //             padding: EdgeInsets.all(8.0),
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.end,
                            //               children: <Widget>[
                            //                 Text(
                            //                   "      ",
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: cHeight * 0.02),
                            //                 ),
                            //                 // Icon(
                            //                 //   Icons.navigate_next,
                            //                 //   color: Colors.white,
                            //                 // )
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
      ),
    );
  }
}
