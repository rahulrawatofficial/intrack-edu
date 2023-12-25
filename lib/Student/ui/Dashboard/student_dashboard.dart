import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/Student/ui/Attendance/attendanceM.dart';
import 'package:intrack/Student/ui/Birthdays/student_birthdays.dart';
import 'package:intrack/Student/ui/Courses/courses_detail.dart';
import 'package:intrack/Student/ui/Courses/courses_tab.dart';
import 'package:intrack/Student/ui/Diary/diaryPage.dart';
import 'package:intrack/Student/ui/EventAndHolidays/event_and_holiday_page.dart';
import 'package:intrack/Student/ui/Gallery/gallery_page.dart';
import 'package:intrack/Student/ui/LeavePage/leave_page.dart';
// import 'package:lexin/Student/ui/Events/events.dart';
import 'package:intrack/Student/ui/News/news.dart';
import 'package:intrack/Student/ui/NoticeBoard/notice_board_page.dart';
import 'package:intrack/Student/ui/Notifications/notifications_page.dart';
// import 'package:lexin/Student/ui/Notifications/notifications.dart';
import 'package:intrack/Student/ui/Reminders/reminders.dart';
import 'package:intrack/Student/ui/ResultU/result_main.dart';
import 'package:intrack/Student/ui/SocialMedia/social_media_page.dart';
import 'package:intrack/Student/ui/Syllabus/syllabus_page.dart';
import 'package:intrack/Student/ui/TimeTable/new_timetable.dart';
import 'package:intrack/Student/ui/TimeTable/timetable.dart';
import 'package:intrack/Student/ui/homework/homework_page.dart';
// import 'package:intrack/VideoCalling/calling_screen.dart';
import 'package:intrack/VideoCalling/dlink_calling_screen.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:intrack/Student/ui/StudentProfile/student_profile.dart';

// List<JsonMap>
var mydata;
double cHeight;
double cWidth;

class StudentDashBoard extends StatefulWidget {
  final String userToken;
  final String userId;
  final String parentId;
  final String classId;
  final String sectionId;
  final String studentPic;
  StudentDashBoard({
    Key key,
    this.userToken,
    this.userId,
    this.parentId,
    this.classId,
    this.sectionId,
    this.studentPic,
  }) : super(key: key);
  _StudentDashBoardState createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  Key _scaffoldKey = GlobalKey<ScaffoldState>();

  var data;
  String userName;
  List dashboardItems = [
    {"image": "", "text": "Leaves"},
    {"image": "", "text": "Courses"},
    {"image": "", "text": "Attendance"},
    {"image": "", "text": "HomeWork"},
    {"image": "", "text": "Syllabus"},
    {"image": "", "text": "Notice Board"},
    // {"image": "", "text": "Performance"},
    {"image": "", "text": "Time Table"},
    {"image": "", "text": "Social Media"},
    {"image": "", "text": "Birthdays"},
    {"image": "", "text": "Gallery"},
    {"image": "", "text": "Diary"},
    {"image": "", "text": "Reminder"},
    {"image": "", "text": "News"},
    {"image": "", "text": "Events &\n Holidays"},
    // {"image": "", "text": "Calling"},
  ];

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userName = preferences.getString('CurrentUserName');
  }

  @override
  void initState() {
    super.initState();
    print("dashboard ID is ${widget.userId}");
    print("dashboard token is ${widget.userToken}");
    print("parent id is ${widget.parentId}");
    print("section id is ${widget.sectionId}");
    print("class id is ${widget.classId}");
    print("class id is ${widget.userId}");
  }

  _launchButton(int index) {
    if (index == 0)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LeavesPage(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                    classId: widget.classId,
                    sectionId: widget.sectionId,
                  )));
    if (index == 1)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoursesTab(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                    classId: widget.classId,
                    studentName: userName,
                  )));
    if (index == 2)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Attendance(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                  )));
    if (index == 3)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeworkPage(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                  )));
    if (index == 4)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SyllabusPage(
                    userToken: widget.userToken,
                    sectionId: widget.sectionId,
                  )));
    if (index == 5)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoticeBoardPage(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                  )));
    // if (index == 1)
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => NotificationsPage(
    //                 userToken: widget.userToken,
    //                 //initialIndex: 0,
    //               )));
    // if (index == 6)
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => Result(
    //                 userToken: widget.userToken,
    //                 studentId: widget.userId,
    //                 sectionId: widget.sectionId,
    //               )));
    if (index == 6)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TimeTable(
                    userToken: widget.userToken,
                    studentId: widget.userId,
                  )));

    if (index == 7)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SocialMediaPage(
                    userToken: widget.userToken,
                    // userId: widget.parentId,
                  )));
    if (index == 8)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentBirthdays(
                    userToken: widget.userToken,
                    classId: widget.classId,
                    sectionId: widget.sectionId,
                  )));
    if (index == 9)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GalleryPage(
                    userToken: widget.userToken,
                    // userId: widget.parentId,
                  )));
    if (index == 10)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryPage(
            userToken: widget.userToken,
            studentId: widget.userId,
          ),
          // Diary(
          //       userToken: widget.userToken,
          //       initialIndex: 1,
          //     ),
        ),
      );
    if (index == 11)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Reminders(userToken: widget.userToken)));
    if (index == 12)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => News(
                    userToken: widget.userToken,
                    userId: widget.parentId,
                  )));
    if (index == 13)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventHolidayPage(
                    userToken: widget.userToken,
                    // userId: widget.parentId,
                  )));
    // if (index == 14)
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => CallingScreen()));

    // }

    // List<JsonMap> parseJson(String responseBody) {
    //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    //   return parsed.map<JsonMap>((json) => JsonMap.fromJson(json)).toList();
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
        color: Color(0xFF00BAAE),
      ),
      Icon(
        (Icons.equalizer),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.notifications),
        size: cHeight * 0.07,
        color: Color(0xFFFFA800),
      ),
      Icon(
        (Icons.table_chart),
        size: cHeight * 0.07,
        color: Color(0xFF4FB2FE),
      ),
      Icon(
        (Icons.chrome_reader_mode),
        size: cHeight * 0.07,
        color: Color(0xFFC954CC),
      ),
      Icon(
        (Icons.book),
        size: cHeight * 0.07,
        color: Color(0xFF44C5D4),
      ),
      Icon(
        (Icons.note),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.developer_mode),
        size: cHeight * 0.07,
        color: Color(0xFF4FB2FE),
      ),
      Icon(
        (Icons.perm_contact_calendar),
        size: cHeight * 0.07,
        color: Color(0xFFC954CC),
      ),
      Icon(
        (Icons.photo),
        size: cHeight * 0.07,
        color: Color(0xFF00E155),
      ),
      Icon(
        (Icons.alarm),
        size: cHeight * 0.07,
        color: Color(0xFF00E155),
      ),
      Icon(
        (Icons.book),
        size: cHeight * 0.07,
        color: Color(0xFF44C5D4),
      ),
      Icon(
        (Icons.developer_board),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
      ),
      Icon(
        (Icons.perm_contact_calendar),
        size: cHeight * 0.07,
        color: Color(0xFFF5696B),
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
      //   image: new AssetImage("assets/dashboardIcons/Performance.png"),
      // ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Time_Table.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Social_Media.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Birthday.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Gallery.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Diary.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Reminder.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/News.png"),
      ),
      Image(
        height: cHeight * 0.1,
        image: new AssetImage("assets/dashboardIcons/Holidays.png"),
      ),
      // Image(
      //   height: cHeight * 0.1,
      //   image: new AssetImage("assets/dashboardIcons/Homework.png"),
      // ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF444B54),
        elevation: 0.0,
        title: Padding(
          padding: EdgeInsets.only(
            left: cWidth * 0.35,
          ),
          child: Text(''),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(
                      userToken: widget.userToken,
                      studentId: widget.userId,
                    ),
                  ));
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(
                      userToken: widget.userToken,
                      userId: widget.userId,
                      studentPic: widget.studentPic,
                    ),
                  ));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return FutureBuilder(
                    future: getUserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: cHeight * 0.2,
                          width: cWidth,
                          color: Color(0xFF444B54),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: cWidth * 0.07,
                                    bottom: cHeight * 0.07),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: widget.studentPic != null
                                      ? NetworkImage(widget.studentPic)
                                      : AssetImage("assets/demokid.jpg"),
                                  radius: cWidth * 0.08,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: cHeight * 0.025, left: cWidth * 0.06),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: cWidth * 0.65,
                                      child: Text(
                                        "Hello $userName,",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: cHeight * 0.005),
                                    ),
                                    Text("Welcome to Intrack",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else
                        return Container(
                          height: cHeight * 0.2,
                          width: cWidth,
                          color: Color(0xFFf7418c),
                        );
                    });
              }),
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
                    padding: EdgeInsets.all(cWidth * 0.04),
                    child: GridView.count(
                      crossAxisCount:
                          Orientation.portrait == oreintaion ? 2 : 3,
                      children: List.generate(
                        dashboardItems.length,
                        (index) {
                          return Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(cWidth * 0.014),
                            child: InkWell(
                              // borderRadius: BorderRadius.circular(25.0),
                              highlightColor: Colors.white,
                              splashColor: Colors.blue,
                              onTap: () {
                                print('Done $index');
                                _launchButton(index);
                              },
                              child: Card(
                                // color: Colors.white.withOpacity(0.8),

                                elevation: 10.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    images[index],
                                    // new Image(
                                    //   height: cHeight * 0.1,
                                    //   image: new AssetImage(
                                    //       "assets/dashboardIcons/homework.png"),
                                    // ),
                                    new Text(
                                      dashboardItems[index]["text"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
