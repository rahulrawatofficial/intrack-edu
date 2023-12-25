import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intrack/Teacher/blocs/get_leaves_list_bloc.dart';
import 'package:intrack/Teacher/models/leaves_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Teacher/resources/LeavesList/get_leaves_list_api.dart';

class RejectedLeaves extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  RejectedLeaves({
    Key key,
    this.userToken,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _RejectedLeavesState createState() => _RejectedLeavesState();
}

class _RejectedLeavesState extends State<RejectedLeaves> {
  final List<String> items = List.generate(30, (i) => 'Item no ${i + 1}');
  double cHeight;
  double cWidth;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future _updateLeave(String leaveId, String status) async {
    final url = "https://api-dashboard.intrack.in/v1/updateLeaveByTeacher";
    final response = await http.put(
      Uri.encodeFull(url),
      body: {
        "leaveId": leaveId,
        "status": status,
      },
      headers: {
        "authorization": "Bearer " + widget.userToken,
      },
    );
    print("upload response: ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      // scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text("Leave $status"),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    LeavesListApi leavesListApi = LeavesListApi();
    // leavesListBloc.fetchAllLeavesList(
    //   widget.userToken,
    //   context,
    //   widget.classId,
    //   widget.sectionId,
    //   "REJECTED",
    // );
    print(widget.classId);
    print(widget.sectionId);
    return FutureBuilder(
      future: leavesListApi.getLeavesList(
          widget.userToken, context, widget.sectionId, "REJECTED"),
      builder: (context, AsyncSnapshot<LeavesListModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.data.length == 0) {
            return Center(
              child: Text("No data found"),
            );
          } else {
            return Column(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text(
                    'Swipe left to Approve',
                    style: TextStyle(fontSize: cHeight * 0.016),
                  )),
                  color: Colors.grey[300],
                  width: cWidth,
                  height: cHeight * 0.05,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print('object');
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            color: Colors.white,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.data[index].leaveTitle,
                                          style: TextStyle(
                                            fontSize: cHeight * 0.02,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Text(
                                            snapshot.data.data[index]
                                                .leaveDescription,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          snapshot
                                              .data.data[index].studentId.name,
                                          style: TextStyle(
                                            fontSize: cHeight * 0.02,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Approve',
                              color: Colors.green,
                              icon: Icons.check,
                              onTap: () {
                                _updateLeave(snapshot.data.data[index].id,
                                        "APPROVED")
                                    .then((val) {
                                  setState(() {});
                                  // leavesListBloc.fetchAllLeavesList(
                                  //     widget.userToken,
                                  //     context,
                                  //     widget.classId,
                                  //     widget.sectionId,
                                  //     "PENDING");
                                });
                              },
                            ),
                            // IconSlideAction(
                            //   caption: 'Reject',
                            //   color: Colors.red,
                            //   icon: Icons.cancel,
                            //   onTap: () {
                            //     _updateLeave(
                            //             snapshot.data.data[index].id, "REJECTED")
                            //         .then((val) {
                            //       setState(() {});
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
