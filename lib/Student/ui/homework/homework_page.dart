import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';
import 'package:intrack/Student/blocs/get_homework_bloc.dart';
import 'package:intrack/Student/models/get_homework_model.dart';
import 'package:intrack/Student/resources/Homework/get_homework_api.dart';
import 'package:intrack/Student/ui/homework/homework_details_page.dart';

class HomeworkPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  HomeworkPage({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  //List data;
  double cHieght;
  double cWidth;
  GetHomeworkApi getHomeworkApi = GetHomeworkApi();

  void showDialogSingleButton(
      BuildContext context, String title, String message, String buttonLabel) {
//flutter define function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //return object of type dialoge
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      ModalRoute.withName('HomePage'));
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    // print("Homework token ${widget.userToken}");
    // getHomeworkApi.userToken = widget.userToken;
  }

  @override
  Widget build(BuildContext context) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.fromLTRB(
        cWidth * 0.01, cHieght * 0.01, cWidth * 0.01, cHieght * 0.01);

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var c = cHieght;
      cHieght = cWidth;
      cWidth = c;
    }
    homeworkBloc.fetchAllHomework(widget.userToken, widget.studentId, context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Homework"),
      ),
      body: StreamBuilder(
        stream: homeworkBloc.allHomework,
        builder: (context, AsyncSnapshot<HomeworkModel> snapshot) {
          print(snapshot.connectionState);
          //print(snapshot.data.data);
          // if (snapshot.connectionState == ConnectionState.done) {
          //   if (snapshot.hasError) return Error();
          if (snapshot.hasData) {
            if (snapshot.data.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Card(
                  //   child: Text(snapshot.data.data[index].id),
                  // );
                  return GestureDetector(
                    onTap: () {
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) => HomeworkDetails(
                                value: snapshot.data,
                                currentIndex: index,
                                date: snapshot.data.data[index].id,
                                // selectedDate:
                                //     listOfDates[index].toString().substring(0, 10),
                              ));
                      Navigator.of(context).push(route);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomeworkDetails()),
                      // );
                    },
                    child: new Card(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: _pad,
                            child: Padding(
                              padding: _pad,
                              child: dateCircle(index, snapshot),
                            ),
                          ),
                          new Container(
                            child: new Row(
                              children: <Widget>[
                                new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: _pad,
                                      //snapshot.data.data.length
                                      child: snapshot.data.data[index].homework
                                                  .length ==
                                              0
                                          ? null
                                          : subjectContainer(snapshot
                                              .data
                                              .data[index]
                                              .homework[0]
                                              .subjectName),
                                    ),
                                    Padding(
                                      padding: _pad,
                                      child: snapshot.data.data[index].homework
                                                  .length >
                                              1
                                          ? subjectContainer(snapshot
                                              .data
                                              .data[index]
                                              .homework[1]
                                              .subjectName)
                                          : null,
                                    )
                                  ],
                                ),
                                new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: _pad,
                                      child: snapshot.data.data[index].homework
                                                  .length >
                                              2
                                          ? subjectContainer(snapshot
                                              .data
                                              .data[index]
                                              .homework[2]
                                              .subjectName)
                                          : null,
                                    ),
                                    Padding(
                                      padding: _pad,
                                      child: snapshot.data.data[index].homework
                                                  .length >
                                              3
                                          ? subjectContainer(snapshot
                                                      .data
                                                      .data[index]
                                                      .homework
                                                      .length >
                                                  4
                                              ? (snapshot.data.data[index]
                                                              .homework.length -
                                                          3)
                                                      .toString() +
                                                  "+"
                                              : snapshot.data.data[index]
                                                  .homework[3].subjectName)
                                          : null,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: _pad,
                            child: Icon(Icons.navigate_next),
                          )
                        ],
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
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  //Subject Name Container
  Container subjectContainer(String subjectName) {
    return new Container(
        decoration: new BoxDecoration(
            color: Colors.grey[200],
            //border: new Border.all(color: Colors.grey),
            borderRadius: new BorderRadius.all(Radius.circular(3))),
        height: cHieght * 0.032,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? cWidth * 0.28
            : cHieght * 0.35,
        child: Center(
            child: new Text(
          subjectName,
          style: new TextStyle(fontSize: cWidth * 0.036),
        )));
  }

  //Circle Avatar For Date
  CircleAvatar dateCircle(int index, AsyncSnapshot snapshot) {
    return CircleAvatar(
        radius: cWidth * 0.1,
        backgroundColor: Colors.grey[300],
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              snapshot.data.data[index].id.toString().substring(8, 10),
              style:
                  new TextStyle(fontSize: cHieght * 0.025, color: Colors.white),
            ),
            new Text(
              //data[index]['date'].toString().substring(5, 7),

              new DateFormat.MMM()
                  .format(DateTime.parse(snapshot.data.data[index].id)),
              style:
                  new TextStyle(fontSize: cHieght * 0.025, color: Colors.white),
            ),
          ],
        ));
  }
}
