import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intrack/Teacher/blocs/students_info_list_bloc.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/ui/StudentsInfoList/students_info.dart';
import 'package:intrack/Teacher/ui/UploadHomework/uploadhomework.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentInfoList extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  StudentInfoList({
    Key key,
    this.userToken,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _StudentInfoListState createState() => _StudentInfoListState();
}

class _StudentInfoListState extends State<StudentInfoList> {
  final List<String> items = List.generate(30, (i) => 'Item no ${i + 1}');
  double cHeight;
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    studentsInfoBloc.fetchAllStudentsInfoList(
        widget.userToken, context, widget.classId, widget.sectionId);
    print(widget.classId);
    print(widget.sectionId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
      ),
      body: StreamBuilder(
          stream: studentsInfoBloc.allStudentsInfoList,
          builder: (context, AsyncSnapshot<StudentsInfoModel> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Container(
                    child: Center(
                        child: Text(
                      'Swipe left to make call',
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
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ParticularStudentInfo(
                                      studentInfoData:
                                          snapshot.data.data[index],
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFFFF6144),
                                  backgroundImage:
                                      snapshot.data.data[index].profilePicUrl !=
                                              null
                                          ? NetworkImage(snapshot
                                              .data.data[index].profilePicUrl)
                                          : null,
                                  // child: Text(snapshot.data.data[index].name
                                  //     .substring(0, 1)),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(snapshot.data.data[index].name),
                                // subtitle: Text('SlidableDrawerDelegate'),
                              ),
                            ),
                            // actions: <Widget>[
                            //   IconSlideAction(
                            //     caption: 'Archive',
                            //     color: Colors.blue,
                            //     icon: Icons.archive,
                            //     // onTap: () => _showSnackBar('Archive'),
                            //   ),
                            //   IconSlideAction(
                            //     caption: 'Share',
                            //     color: Colors.indigo,
                            //     icon: Icons.share,
                            //     // onTap: () => _showSnackBar('Share'),
                            //   ),
                            // ],
                            secondaryActions: <Widget>[
                              // IconSlideAction(
                              //   caption: 'More',
                              //   color: Colors.black45,
                              //   icon: Icons.more_horiz,
                              //   // onTap: () => _showSnackBar('More'),
                              // ),
                              IconSlideAction(
                                caption: 'Call',
                                color: Colors.red,
                                icon: Icons.call,
                                onTap: () => launch(
                                    "tel://${snapshot.data.data[index].parentId.fatherCellNo}"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
