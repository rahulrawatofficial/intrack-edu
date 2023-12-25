import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/models/diary/task.dart';
import 'package:intrack/Teacher/blocs/get_student_diary_bloc.dart';
import 'package:intrack/Teacher/models/get_teacher_diary_model.dart';
import 'package:intrack/Teacher/ui/TeacherDiary/add_diary.dart';
import 'package:intrack/Teacher/ui/TeacherDiary/animatedFAB.dart';
import 'package:intrack/Teacher/ui/TeacherDiary/task_row.dart';

class TeacherDiaryPage extends StatefulWidget {
  final Widget child;
  final String userToken;
  final studentData;
  final String classId;
  final String sectionId;
  TeacherDiaryPage({
    Key key,
    this.child,
    this.userToken,
    this.studentData,
    this.classId,
    this.sectionId,
  }) : super(key: key);

  _TeacherDiaryPageState createState() => _TeacherDiaryPageState();
}

var cHeight, cWidth;
var currentDate = DateTime.now();
// List<Task> tasks = [
//   Task(
//     date: DateTime(currentDate.year, currentDate.month, currentDate.day),
//     name: "Please make your ward to complete homework daily",
//     category: "Mobile Project",
//     time: "5pm",
//     color: Colors.orange,
//     completed: false,
//     image: "assets/img/mars.png",
//   ),
//   Task(
//     date: DateTime(currentDate.year, currentDate.month, currentDate.day),
//     name: "Make  icons",
//     category: "Web App",
//     time: "3pm",
//     color: Colors.cyan,
//     completed: true,
//     image: "assets/img/earth.png",
//   ),
//   Task(
//     date: DateTime(currentDate.year, currentDate.month, currentDate.day),
//     name: "Design explorations",
//     category: "Company Website",
//     time: "2pm",
//     color: Colors.orange,
//     completed: false,
//     image: "assets/img/neptune.png",
//   ),
// ];

class _TeacherDiaryPageState extends State<TeacherDiaryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AnimatedFab animatedFab = AnimatedFab();
  @override
  Widget build(BuildContext context) {
    // print(tasks);
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    getTeacherDiaryBloc.fetchAllDiary(widget.userToken, context);

    return StreamBuilder(
      stream: getTeacherDiaryBloc.allDiary,
      builder: (context, AsyncSnapshot<GetTeacherDiaryModel> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xFFFF6144),
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDiary(
                      userToken: widget.userToken,
                      classId: widget.classId,
                      sectionId: widget.sectionId,
                      // studentData: widget.studentData,
                    ),
                  ),
                );
              },
            ),
            key: scaffoldKey,
            body: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color(0xFFFF6144),
                    title: Text(
                      "Diary",
                    ),
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        "assets/img/carvedStones.jpg",
                        fit: BoxFit.cover,
                        width: cWidth,
                        colorBlendMode: BlendMode.srcOver,
                        color: Color.fromRGBO(149, 190, 52, 70.0),
                      ),
                    ),
                    pinned: true,
                    // floating: true,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  _buildTasksList(snapshot),
                  // SliverFillRemaining(),
                ],
              ),
            ),
            // floatingActionButton: _buildFab(context),
          );
        } else
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }

  Widget _buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 45,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildTasksList(AsyncSnapshot<GetTeacherDiaryModel> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          bool printDate = true;

          if (index != 0) if (snapshot.data.data[index].date.substring(0, 10) ==
              snapshot.data.data[index - 1].date.substring(0, 10))
            printDate = false;
          return Stack(
            children: <Widget>[
              _buildTimeline(),
              TaskRow(
                task: snapshot.data.data[index],
                printDate: printDate,
                userToken: widget.userToken,
                diaryId: snapshot.data.data[index].id,
              ),
            ],
          );
        },
        childCount: snapshot.data.data.length,
      ),
    );
    // return ListView(
    //   children: tasks.map((task) => TaskRow(task: task)).toList(),
    // );
  }

  // Widget _buildFab(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () => _addConversation,
  //     backgroundColor: Color(0xFF736AB7),
  //     child:
  //         // AnimatedFab(
  //         //   onClick: _changeFilterState,
  //         // ),
  //         Icon(Icons.add),
  //   );
  // }

  bool showOnlyCompleted = false;
  void _changeFilterState() {
    // showOnlyCompleted = !showOnlyCompleted;
    // tasks.where((task) => !task.completed).forEach((task) {
    //   if (showOnlyCompleted) {
    //     listModel.removeAt(listModel.indexOf(task));
    //   } else {
    //     listModel.insert(tasks.indexOf(task), task);
    //   }
    // });
  }

  _addConversation() {
    print("Wanna talk with your teacher");
  }
}

Widget dateCondition(DateTime date) {
  // print("date $date");
  // print("dateType ${date.runtimeType}");
  return Padding(
    padding: EdgeInsets.only(
      left: cWidth * 0.1,
      // cWidth * 0.035,
      bottom: cHeight * 0.02,
    ),
    child: DateTime(
              date.year,
              date.month,
              date.day,
            ) ==
            DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
            )
        ? Text(
            "Today",
            style: TextStyle(
              fontSize: cHeight * 0.035,
              fontWeight: FontWeight.w400,
            ),
          )
        : Text(
            DateFormat.yMMMEd().format(date).toString(),
            // "hjhkhj",
            style: TextStyle(
              fontSize: cHeight * 0.0325,
              fontWeight: FontWeight.w400,
            ),
          ),
  );
}
