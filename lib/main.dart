import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/ForceUpdate/force_update_alert.dart';
import 'package:intrack/ForceUpdate/force_update_screen.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';
import 'package:intrack/Student/ui/Dashboard/student_dashboard.dart';
// import 'package:intrack/Student/ui/Dashboard/student_dashboard.dart';
import 'package:intrack/Student/ui/MpinPage/mpin_page.dart';
import 'package:intrack/Teacher/ui/Dashboard/teacher_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userToken;
  String userId;
  String userRole = "PARENT";
  String parentId;
  String classId;
  String sectionId;
  String studentPic;
  String studentName;
  int mPin;
  bool pinExist;
  bool pinMatch = false;
  var studentPrimaryColor = Color(0xFF444B54);
  var teacherPrimaryColor = Color(0xFFFF6144);

  bool needUpdate = false;

  Future getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      mPin = preferences.getInt('mPin');
      pinExist = preferences.getBool('pinExist');

      print(mPin.toString() + "*********");
      userToken = preferences.getString('CurrentUserToken');
      userRole = preferences.getString('CurrentUserRole');
      userId = preferences.getString('CurrentUserId');
      parentId = preferences.getString('parentId');
      classId = preferences.getString('classId');
      sectionId = preferences.getString('sectionId');
      studentPic = preferences.getString('studentPic');
      studentName = preferences.getString('CurrentUserName');
    });
  }

  onPinMatch() {
    print("f");
    setState(() {
      pinMatch = true;
    });
  }

  @override
  void initState() {
    getUserToken().then((onValue) {
      versionCheck(context).then((val) {
        getLatestVersion(context, userToken).then((ver) {
          print("current version: $ver");
          if (val < ver) {
            setState(() {
              needUpdate = true;
            });
          } else {
            setState(() {
              needUpdate = false;
            });
          }
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Intrack",
        theme: ThemeData(
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          ),
          primaryIconTheme: IconThemeData(color: Colors.white),
          //textTheme: TextTheme(headline: TextStyle(color: Colors.white),),
          // primarySwatch: Colors.blue,
          primaryColor: userRole == "TEACHER"
              ? teacherPrimaryColor
              : userRole == "PARENT"
                  ? studentPrimaryColor
                  : teacherPrimaryColor,
          // backgroundColor: Color(0XFF344955),
          colorScheme: ColorScheme(
            error: Color(0xFFB00020),
            background: Color(0xFFFFFFFF),
            brightness: Brightness.light,
            primary: Color(0xFFf7418c),
            secondary: Colors.teal[200],
            onBackground: Colors.white,
            onError: Colors.white,
            primaryVariant: Color(0xFF3700B3),
            secondaryVariant: Color(0XFF018786),
            onPrimary: Color(0XFFFFFFFF),
            onSecondary: Color(0XFF000000),
            onSurface: Color(0XFF000000),
            surface: Color(0XFFFFFFFF),
          ),

          // accentColor: Color(0xFFF9A33),
          // brightness: Brightness.light,
        ),
        home: Provider<DeepLinkBloc>(
            create: (context) => _bloc,
            // dispose: (context, bloc) => bloc.dispose(),
            child: needUpdate
                ? ForcaUpdateScreen()
                : userToken == null
                    ? LoginPage()
                    : userRole == "TEACHER"
                        ? TeacherDashBoard(
                            userToken: userToken,
                            userId: userId,
                            teacherPic: studentPic,
                          )
                        // ? StudentDashBoard(
                        //     userToken: userToken,
                        //     userId: userId,
                        //     parentId: parentId,
                        //     classId: classId,
                        //     sectionId: sectionId,
                        //     studentPic: studentPic,
                        //   )
                        : MpinPage(
                            userToken: userToken,
                            userId: userId,
                            parentId: parentId,
                            classId: classId,
                            sectionId: sectionId,
                            studentPic: studentPic,
                            pinExist: pinExist,
                            mPin: mPin,
                            studentName: studentName,
                          )));
  }
}
