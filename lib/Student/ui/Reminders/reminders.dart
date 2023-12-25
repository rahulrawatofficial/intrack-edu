import 'package:flutter/material.dart';
import 'package:intrack/Functions/error.dart';
import 'package:intrack/Student/resources/reminder/getReminderListApi.dart';
import 'package:intrack/Student/ui/Reminders/addReminders.dart';
import 'package:intrack/Student/ui/Reminders/updateReminder.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Reminders extends StatefulWidget {
  final String userToken;
  Reminders({Key key, this.userToken}) : super(key: key);
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  double cHeight, cWidth;
  var data;

  // Future<void> getData() async {
  //   data = await getReminderList(context, widget.userToken);
  //   print("^^${data}");
  // }

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
            builder: (BuildContext context) => AddReminders(
              userToken: widget.userToken,
            ),
          );
          Navigator.of(context).push(route);
        },
      ),
      appBar: AppBar(
        title: Text("Reminders"),
      ),
      backgroundColor: Colors.brown[50],
      body: FutureBuilder(
        future: getReminderList(context, widget.userToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("##${snapshot.data["data"].length}");
            if (snapshot.hasError) return errorCheck();
            if (snapshot.data["data"].length > 0) {
              return ListView.builder(
                itemCount: snapshot.data["data"].length,
                itemBuilder: (BuildContext context, int index) {
                  var dateLast = DateTime(
                    int.parse(
                      snapshot.data["data"][index]["lastDate"]
                          .toString()
                          .substring(0, 4),
                    ),
                    int.parse(
                      snapshot.data["data"][index]["lastDate"]
                          .toString()
                          .substring(5, 7),
                    ),
                    int.parse(
                      snapshot.data["data"][index]["lastDate"]
                          .toString()
                          .substring(8, 10),
                    ),
                  );
                  var date2 = DateTime.now();
                  var difference = dateLast.difference(date2).inDays;
                  var differenceHours = dateLast.difference(date2).inHours;
                  // print("llllllllllssssssssstttttt ${data.length} $dateLast");
                  print(differenceHours);
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateReminder(
                          userToken: widget.userToken,
                          description: snapshot.data["data"][index]
                              ["description"],
                          lastDate: snapshot.data["data"][index]["lastDate"],
                          title: snapshot.data["data"][index]["title"],
                          reminderId: snapshot.data["data"][index]["_id"],
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: _pad,
                      child: differenceHours < 1
                          ? null
                          : Card(
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              differenceHours > 24
                                                  ? Text(
                                                      difference.toString() +
                                                          " days to go",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: difference < 5
                                                              ? Colors.red[700]
                                                              : Colors
                                                                  .green[700]),
                                                    )
                                                  : Text(
                                                      differenceHours
                                                              .toString() +
                                                          " hours to go",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: difference < 5
                                                              ? Colors.red[700]
                                                              : Colors
                                                                  .green[700]),
                                                    ),
                                              Text(
                                                snapshot.data["data"][index]
                                                        ["lastDate"]
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: difference < 5
                                                      ? Colors.red[700]
                                                      : Colors.green[700],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                cWidth * 0.05,
                                                cHeight * 0.04,
                                                cWidth * 0.05,
                                                cHeight * 0.04),
                                            child: Text(
                                              snapshot.data['data'][index]
                                                  ['description'],
                                              style: TextStyle(
                                                  fontSize: cHeight * 0.025),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: null,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(3),
                                                  bottomRight:
                                                      Radius.circular(3)),
                                              color: difference < 5
                                                  ? Colors.red[400]
                                                  : Colors.green[400],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    "      ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            cHeight * 0.02),
                                                  ),
                                                  // Icon(
                                                  //   Icons.navigate_next,
                                                  //   color: Colors.white,
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}
