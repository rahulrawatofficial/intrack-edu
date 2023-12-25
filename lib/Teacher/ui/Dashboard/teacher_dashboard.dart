import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Teacher/blocs/get_leaves_list_bloc.dart';
import 'package:intrack/Teacher/models/leaves_list_model.dart';
import 'package:intrack/Teacher/ui/Courses/courses_detail.dart';
import 'package:intrack/Teacher/ui/EventAndHolidays/event_and_holiday_page.dart';
import 'package:intrack/Teacher/ui/Leaves/leaves_list.dart';
import 'package:intrack/Teacher/ui/NoticeBoard/upload_notice.dart';
import 'package:intrack/Teacher/ui/StudentsInfoList/students_list.dart';
import 'package:intrack/Teacher/ui/TeacherDiary/teacher_diary_page.dart';
import 'package:intrack/Teacher/ui/TeacherProfile/teacherprofile.dart';
import 'package:intrack/Teacher/ui/UploadAttendance/upload_attendance_main.dart';
import 'package:intrack/Teacher/ui/UploadHomework/upload_homework_main.dart';
import 'package:intrack/Teacher/ui/UploadResult/uploadresult.dart';
import 'package:intrack/Teacher/ui/UploadSyllabus/upload_syllabus_main.dart';
import 'package:intrack/VideoCalling/dlink_calling_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intrack/Teacher/models/get_section_list_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swipedetector/swipedetector.dart';
import 'package:provider/provider.dart';

double cHeight;
double cWidth;

class TeacherDashBoard extends StatefulWidget {
  final String userToken;
  final String userId;
  final int selectedIndex;
  final String teacherPic;
  TeacherDashBoard(
      {Key key,
      this.userToken,
      this.selectedIndex,
      this.userId,
      this.teacherPic})
      : super(key: key);
  _TeacherDashBoardState createState() => _TeacherDashBoardState();
}

class _TeacherDashBoardState extends State<TeacherDashBoard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var classData;
  List classNum = [];
  List sectionName = [];
  List subjectNames = [];
  int selectedIndex = 0;

  String currentClass;
  String currentSection;

  String userName;
  List dashboardItems = [
    {"image": "", "text": "Leaves"},
    {"image": "", "text": "Courses"},
    {"image": "", "text": "Upload Attendance"},
    {"image": "", "text": "Upload HomeWork"},
    {"image": "", "text": "Upload Syllabus"},
    {"image": "", "text": "Upload Notice"},
    {"image": "", "text": "Students Info"},
    // {"image": "", "text": "Upload Result"},
    {"image": "", "text": "Diary"},
    {"image": "", "text": "Events &\nHolidays"},
  ];

  Future getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString('CurrentUserName');
      // selectedIndex = preferences.getInt('classIndex') != null
      //     ? preferences.getInt('classIndex')
      //     : 0;
    });
  }

  Future saveClassIndex(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('classIndex', index);
  }

  Future<SectionListModel> getSectionList() async {
    String path = "/v1/getAllSections";
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + widget.userToken
      },
    );
    if (response.statusCode == 200) {
      classNum.clear();
      sectionName.clear();
      print("^^^$classData^^^");
      setState(() {
        classData = json.decode(response.body);
        for (int i = 0; i < classData["data"].length; i++) {
          classNum.add(classData["data"][i]["classData"]["classNum"]);
        }
        for (int i = 0; i < classData["data"].length; i++) {
          sectionName.add(classData["data"][i]["name"]);
        }
        if (selectedIndex != null) {
          for (int i = 0;
              i <
                  classData["data"][selectedIndex]["classData"]["subjects"]
                      .length;
              i++) {
            subjectNames.add(classData["data"][selectedIndex]["classData"]
                ["subjects"][i]["subjectName"]);
          }
        }
      });
      print(response.body);

      print(sectionName);
      print(classNum);
      print("selected index: $selectedIndex");
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", widget.userToken, "TEACHER");
    }
    // return SectionListModel.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    print("dashboard ID is ${widget.userId}");
    print("dashboard token is ${widget.userToken}");
    getUserDetails().then((val) {
      getSectionList();
    });
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return classListSheet(classNum, sectionName);
        });
  }

  _launchButton(int index) {
    if (index == 0 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 0)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LeavesList(
                    userToken: widget.userToken,
                    classId: classData["data"][selectedIndex]['classId'],
                    sectionId: classData["data"][selectedIndex]['_id'],
                  )));
    if (index == 1 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 1)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TCourseDetail(
            userToken: widget.userToken,
            studentName: userName,
            // classData: classData["data"][selectedIndex],
            // sectionId: classData["data"][selectedIndex]['_id'],
            classId: classData["data"][selectedIndex]['classId'],
          ),
        ),
      );
    if (index == 2 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 2)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadAttendanceMain(
            userToken: widget.userToken,
            classData: classData["data"][selectedIndex],
            sectionId: classData["data"][selectedIndex]['_id'],
            classId: classData["data"][selectedIndex]['classId'],
          ),
        ),
      );
    if (index == 3 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 3)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadHomeworkMain(
            userToken: widget.userToken,
            classData: classData["data"][selectedIndex],
            sectionId: classData["data"][selectedIndex]['_id'],
            subjects: subjectNames,
          ),
        ),
      );
    if (index == 4 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 4)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadSyllabusMain(
                    userToken: widget.userToken,
                    classId: classData["data"][selectedIndex]['classId'],
                    sectionId: classData["data"][selectedIndex]['_id'],
                    subjects: subjectNames,
                  )));
    if (index == 5 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 5)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadNotice(
                    userToken: widget.userToken,
                    // classId: classData["data"][selectedIndex]['classId'],
                    sectionId: classData["data"][selectedIndex]['_id'],
                  )));

    if (index == 6 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 6)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentInfoList(
                    userToken: widget.userToken,
                    classId: classData["data"][selectedIndex]['classId'],
                    sectionId: classData["data"][selectedIndex]['_id'],
                  )));
    // if (index == 6 && selectedIndex == null)
    //   showDialogSingleButton(
    //       context, "Class not selected", "Please select the class", "OK");
    // else if (index == 6)
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => UploadResult(
    //                 userToken: widget.userToken,
    //                 studentData: classData["data"][selectedIndex],
    //                 subjects: subjectNames,
    //               )));
    if (index == 7 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 7)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherDiaryPage(
                    userToken: widget.userToken,
                    studentData: classData["data"][selectedIndex],
                    sectionId: classData["data"][selectedIndex]['_id'],
                    classId: classData["data"][selectedIndex]['classId'],
                  )));
    if (index == 8 && selectedIndex == null)
      showDialogSingleButton(
          context, "Class not selected", "Please select the class", "OK");
    else if (index == 8)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherEventHolidayPage(
                    userToken: widget.userToken,
                  )));
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    Orientation oreintaion = MediaQuery.of(context).orientation;

    List<Icon> icons = [
      Icon(
        (Icons.book),
        size: cHeight * 0.07,
        color: Color(0xFFFFD000),
      ),
      Icon(
        (Icons.equalizer),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.chrome_reader_mode),
        size: cHeight * 0.07,
        color: Color(0xFF009DEA),
      ),
      Icon(
        (Icons.event),
        size: cHeight * 0.07,
        color: Color(0xFF44C5D4),
      ),
      Icon(
        (Icons.people_outline),
        size: cHeight * 0.07,
        color: Color(0xFF44C5D4),
      ),
      Icon(
        (Icons.note),
        size: cHeight * 0.07,
        color: Color(0xFF009DEA),
      ),
      Icon(
        (Icons.equalizer),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.developer_board),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.chrome_reader_mode),
        size: cHeight * 0.07,
        color: Color(0xFF009DEA),
      ),
    ];

    List<Image> images = [
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Leaves.png"),
      ),

      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Diary.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Attendance.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Homework.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Syllabus.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Notice_Board.png"),
      ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/Time_Table.png"),
      // ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/Social_Media.png"),
      // ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/Birthday.png"),
      // ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Gallery.png"),
      ),

      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Performance.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Diary.png"),
      ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/Reminder.png"),
      // ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/News.png"),
      // ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Holidays.png"),
      ),
    ];

    if (classData != null && selectedIndex != null) {
      leavesListBloc.fetchAllLeavesList(
        widget.userToken,
        context,
        classData["data"][selectedIndex]['classId'],
        classData["data"][selectedIndex]['_id'],
        "PENDING",
      );
    }
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          print("##${snapshot.data}##");
          if (!snapshot.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Color(0xFFFF6144),
                elevation: 0.0,
                title: Padding(
                  padding: EdgeInsets.only(
                    left: cWidth * 0.35,
                  ),
                  child: Text(''),
                ),
                actions: <Widget>[
                  classData != null
                      ? Container(
                          height: cHeight * 0.01,
                          width: cWidth * 0.19,
                          child: FlatButton(
                            child: Text(
                              selectedIndex == null
                                  ? "Class"
                                  : "${classNum[selectedIndex]} ${sectionName[selectedIndex]}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: cHeight * 0.02),
                            ),
                            onPressed: () {
                              _showModalSheet();
                            },
                          ),
                        )
                      : Offstage(),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherProfile(
                              userToken: widget.userToken,
                              userId: widget.userId,
                              teacherPic: widget.teacherPic,
                            ),
                          ));
                    },
                  ),
                ],
              ),
              body: classData != null
                  ? GestureDetector(
                      child: StreamBuilder(
                          stream: leavesListBloc.allLeavesList,
                          builder: (context,
                              AsyncSnapshot<LeavesListModel> snapshot) {
                            if (snapshot.hasData) {
                              return Stack(
                                children: <Widget>[
                                  SwipeDetector(
                                    onSwipeDown: () {
                                      setState(() {
                                        classData = null;
                                        getSectionList().then((val) {
                                          subjectNames.clear();
                                          setState(() {
                                            for (int i = 0;
                                                i <
                                                    classData["data"][
                                                                    selectedIndex]
                                                                ["classData"]
                                                            ["subjects"]
                                                        .length;
                                                i++) {
                                              subjectNames.add(classData["data"]
                                                          [selectedIndex]
                                                      ["classData"]["subjects"]
                                                  [i]["subjectName"]);
                                            }
                                            print(subjectNames);
                                          });
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: cHeight * 0.2,
                                      width: cWidth,
                                      color: Color(0xFFFF6144),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: cWidth * 0.07,
                                                bottom: cHeight * 0.07),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: widget
                                                          .teacherPic !=
                                                      null
                                                  ? NetworkImage(
                                                      widget.teacherPic)
                                                  : AssetImage(
                                                      "assets/demoteacher.jpg"),
                                              radius: cWidth * 0.08,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: cHeight * 0.025,
                                                left: cWidth * 0.06),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: cWidth * 0.65,
                                                  child: Text(
                                                    "Hello $userName,",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: cHeight * 0.005),
                                                ),
                                                Text("Welcome to Intrack",
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: cHeight * 0.12,
                                      ),
                                      Expanded(
                                          child: Container(
                                        // color: Theme.of(context).accentColor,
                                        child: Padding(
                                          // padding: const EdgeInsets.all(20.0),
                                          padding:
                                              EdgeInsets.all(cWidth * 0.04),
                                          child: GridView.count(
                                            crossAxisCount:
                                                Orientation.portrait ==
                                                        oreintaion
                                                    ? 2
                                                    : 3,
                                            children: List.generate(
                                              dashboardItems.length,
                                              (index) {
                                                return Padding(
                                                  // padding: const EdgeInsets.all(8.0),
                                                  padding: EdgeInsets.all(
                                                      cWidth * 0.014),
                                                  child: InkWell(
                                                    // borderRadius: BorderRadius.circular(25.0),
                                                    highlightColor:
                                                        Colors.black,
                                                    splashColor: Colors.blue,
                                                    onTap: () {
                                                      print('Done $index');
                                                      _launchButton(index);
                                                    },
                                                    child: Card(
                                                      // color: Colors.white.withOpacity(0.8),

                                                      elevation: 10.0,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          index == 0 &&
                                                                  snapshot
                                                                          .data
                                                                          .data
                                                                          .length >
                                                                      0
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    child: Text(
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .length
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                )
                                                              : Offstage(),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            // crossAxisAlignment:
                                                            //     CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              images[index],
                                                              // new Image(
                                                              //   image: new AssetImage(mydata[index]["image"]),
                                                              // ),
                                                              Center(
                                                                child: Text(
                                                                  dashboardItems[
                                                                          index]
                                                                      ["text"],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            );
          } else {
            return DLinkCallingScreen(
              url: snapshot.data,
              userToken: widget.userToken,
              userId: widget.userId,
              // parentId: widget.parentId,
              // classId: widget.classId,
              // sectionId: widget.sectionId,
              // studentPic: widget.studentPic,
              studentName: userName,
            );
          }
        });
  }

  Container classListSheet(List classNum, List sectionName) {
    return Container(
        height: cHeight * 0.4,
        width: cWidth,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 15.0),
              child: Center(
                  child: Text(
                "Select Class",
                style: TextStyle(
                    fontSize: cHeight * 0.028,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6144)),
              )),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: classNum.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      saveClassIndex(index);
                      getSectionList().then((val) {
                        print(index);
                        subjectNames.clear();
                        setState(() {
                          selectedIndex = index;
                          for (int i = 0;
                              i <
                                  classData["data"][selectedIndex]["classData"]
                                          ["subjects"]
                                      .length;
                              i++) {
                            subjectNames.add(classData["data"][selectedIndex]
                                ["classData"]["subjects"][i]["subjectName"]);
                          }
                          print(subjectNames);
                        });
                      });

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: cWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "${classNum[index]} ${sectionName[index]}",
                                // "hello",
                                style: TextStyle(
                                    fontSize: cHeight * 0.025,
                                    fontWeight: FontWeight.w600),
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  //Alert

  void showDialogSingleButton(
      BuildContext context, String title, String message, String buttonLabel) {
//flutter define function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //return object of type dialoge
          return AlertDialog(
            title: new Text("$title \n"),
            content: new Text(message ?? "Empty"),
            actions: <Widget>[
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showModalSheet();
                },
              )
            ],
          );
        });
  }
}
