import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/blocs/students_birthday_bloc.dart';
import 'package:intrack/Student/models/students_birthday_model.dart';

class StudentBirthdays extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  StudentBirthdays({
    Key key,
    this.userToken,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _StudentBirthdaysState createState() => _StudentBirthdaysState();
}

class _StudentBirthdaysState extends State<StudentBirthdays> {
  final List<String> items = List.generate(30, (i) => 'Item no ${i + 1}');
  double cHeight;
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    studentsBirthdayBloc.fetchAllStudentsBirthdayList(
        widget.userToken, context, widget.classId, widget.sectionId);
    print(widget.classId);
    print(widget.sectionId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Birthday'),
      ),
      body: StreamBuilder(
          stream: studentsBirthdayBloc.allStudentsBirthdayList,
          builder: (context, AsyncSnapshot<StudentsBirthdayModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.data.length > 0) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var d = DateTime.parse(
                              snapshot.data.data[index].dob.toString());
                          var date = DateFormat.d().format(d);
                          var month = DateFormat('MMM').format(d);
                          var year = DateFormat.y().format(d);

                          var displayDate = "$date $month";
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: cHeight * 0.01,
                                  bottom: cHeight * 0.01,
                                  left: cWidth * 0.03,
                                  right: cWidth * 0.03,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: cHeight * 0.027,
                                          backgroundColor: Color(0xFFFF6144),
                                          backgroundImage: snapshot
                                                      .data
                                                      .data[index]
                                                      .profilePicUrl !=
                                                  null
                                              ? NetworkImage(snapshot.data
                                                  .data[index].profilePicUrl)
                                              : null,
                                          // child: Text(snapshot.data.data[index].name
                                          //     .substring(0, 1)),
                                          foregroundColor: Colors.white,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: cWidth * 0.05),
                                          child: Text(
                                            snapshot.data.data[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: cHeight * 0.02),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      displayDate,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: cHeight * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text("No Data Found"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
