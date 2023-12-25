import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intrack/LoginPage/ui/feild.dart';
import 'package:intrack/LoginPage/ui/forgotPassword.dart';

import 'package:intrack/Theme/theme.dart' as Theme;
import 'package:intrack/Functions/bubble_indication_painter.dart';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:intrack/LoginPage/resources/check_login_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

var cHeight, cWidth, r;

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  var _formKeyLoginS = GlobalKey<FormState>();
  var _formKeyLoginT = GlobalKey<FormState>();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  String url = "https://api-dashboard.intrack.in/v1/parentLogin";
  Map data = new Map();
  var _fcmToken;
  String _role = "PARENT";
  CheckLoginApi checkLoginApi = CheckLoginApi();

  final FirebaseMessaging _messaging = FirebaseMessaging();

  int currentPage = 0;
  //LOCAL JSON
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
    _pageController.addListener(() {
      loginEmailController.clear();
      loginPasswordController.clear();
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      int next = _pageController.page.round();
      print("next $next ");
      if (next == 1) {
        _role = "TEACHER";
        url = "https://api-dashboard.intrack.in/v1/teacherLogin";
      } else {
        _role = "PARENT";
        url = "https://api-dashboard.intrack.in/v1/parentLogin";
      }
    });

    firebaseCloudMessagingListeners();

    _messaging.getToken().then((token) {
      print("fcmToken: $token");
      _fcmToken = token;
    });
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermission();

    _messaging.getToken().then((token) {
      print(token);
    });

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message['notification']);
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iosPermission() {
    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //Local Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  localNotification() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  showNotification(msg) async {
    var android = new AndroidNotificationDetails(
      'vizitor pass',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg['title'], msg['body'], platform);
  }

  @override
  void dispose() {
    localNotification();
    loginEmailController?.dispose();
    loginPasswordController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  bool passwordLoginVisible = true;
  Widget iconLoginVisible = new Icon(Icons.visibility_off);

  String _emailLogin;
  String _passwordLogin;

  void _checkLoginPasswordVisibility() {
    passwordLoginVisible = passwordLoginVisible == true ? false : true;
    setState(() {
      iconLoginVisible = passwordLoginVisible == false
          ? new Icon(Icons.visibility)
          : new Icon(Icons.visibility_off);
    });
  }

  bool validandsaveLogin(bool type) {
    print("validandsaveLogin $type");
    final form =
        type ? _formKeyLoginT.currentState : _formKeyLoginS.currentState;
    // print("form $form ");
    // print("formStateStudent ${_formKeyLoginS} ");
    // print("formStateTeacher ${_formKeyLoginT} ");
    if (form.validate()) {
      form.save();
      _emailLogin = loginEmailController.text;
      _passwordLogin = loginPasswordController.text;
      print('email: $_emailLogin\nPassword: $_passwordLogin');
      return true;
    }
    // print("False\nloginEmailController ${loginEmailController.text}");
    // print("loginPasswordController ${loginPasswordController.text}");
    return false;
  }

  void validateandsubmitLogin(bool type) {
    if (validandsaveLogin(type)) {
      try {
        // print("validateandsubmitLogin");
        // print("loginEmailController ${loginEmailController.text}");
        // print("loginPasswordController ${loginPasswordController.text}");
        // print("_fcmToken $_fcmToken");
        // print("_role $_role");
        print("url $url");
        checkLoginApi.email = loginEmailController.text;
        checkLoginApi.password = loginPasswordController.text;
        checkLoginApi.fcmToken = _fcmToken;
        checkLoginApi.role = _role;
        checkLoginApi.checkLogin(context, url);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: cWidth,
            height: cHeight >= 775.0 ? cHeight : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.1),
                  child: Image(
                    width: cWidth / 1.8,
                    height: cHeight / 3.9,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/img/login_logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.027),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    // scrollDirection: Axis.vertical,

                    controller: _pageController,
                    onPageChanged: (i) {
                      print("i $i");
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildLogin(context, false), // for student false
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildLogin(context, true), // for teacher true
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return Container(
      // width: cWidth * 0.71,
      // height: cHeight * 0.067,
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onStudentButtonPress,
                child: Text(
                  "Parent",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onTeacherButtonPress,
                child: Text(
                  "Teacher",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context, bool type) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return Container(
      // duration: Duration(milliseconds: 20000),
      // curve: Curves.easeOutQuart,
      padding: EdgeInsets.only(top: cHeight * 0.031),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: cWidth * 0.71,
                  height: cHeight * 0.253,
                  child: Form(
                    key: type ? _formKeyLoginT : _formKeyLoginS,
                    child: Column(
                      children: <Widget>[
                        feild(
                          context,
                          loginEmailController,
                          "Email or Phone number",
                          Icon(Icons.account_circle),
                          false,
                          IconButton(
                            icon: Icon(Icons.account_circle),
                            onPressed: () {},
                          ),
                          false,
                          true,
                          _emailLogin,
                          TextInputType.emailAddress,
                        ),
                        Container(
                          width: cWidth * 0.59,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        feild(
                          context,
                          loginPasswordController,
                          "Password",
                          Icon(Icons.lock),
                          true,
                          IconButton(
                            icon: iconLoginVisible,
                            color: Color(0xFFF47E50),
                            onPressed: () {
                              _checkLoginPasswordVisibility();
                            },
                          ),
                          passwordLoginVisible,
                          false,
                          _passwordLogin,
                          TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: cHeight * 0.226,
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientEnd,
                      Theme.Colors.loginGradientStart
                    ],
                    begin: const FractionalOffset(0.2, 0.2),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: cHeight / 75,
                      horizontal: cWidth * 0.1,
                    ),
                    child: Text(
                      "Log-In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold",
                      ),
                    ),
                  ),
                  onPressed: () {
                    // print("Role $_role");
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    validateandsubmitLogin(type);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: cHeight / 75),
            child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(
                          role: _role,
                        ),
                      ),
                    ),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          gorgeousLine(context),
        ],
      ),
    );
  }

  void _onStudentButtonPress() {
    _pageController?.animateToPage(0,
        duration: Duration(milliseconds: 870), curve: Curves.easeOutQuart);
  }

  void _onTeacherButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 870), curve: Curves.easeOutQuart);
  }
}

Widget feild(
  BuildContext context,
  TextEditingController controller,
  String labelText,
  Icon prefixIcon,
  bool suffixPresent,
  IconButton suffixIcon,
  bool obsecure,
  bool autocorrect,
  String feildName,
  TextInputType keyboard,
) {
  // suffixPresent=false;
  cHeight = MediaQuery.of(context).size.height;
  cWidth = MediaQuery.of(context).size.width;
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    r = cHeight;
    cHeight = cWidth;
    cWidth = r;
  }
  return Padding(
    padding: EdgeInsets.only(
      top: cHeight * 0.018,
      // bottom: cHeight * 0.02,
      left: cWidth * 0.02,
      right: cWidth * 0.02,
    ),
    child: TextFormField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        // icon: prefixIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixPresent ? suffixIcon : null,
        hintText: labelText,
        hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
      ),
      style: TextStyle(
        fontFamily: "WorkSansSemi",
        fontSize: cHeight * 0.026,
        color: Colors.black,
      ),
      // style: TextStyle(
      //   fontSize: cHeight * 0.026,
      //   color: Colors.black,
      // ),
      keyboardType: keyboard,
      textInputAction: TextInputAction.done,
      obscureText: obsecure,
      autocorrect: autocorrect,
      onSaved: (value) => feildName = value,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the $labelText';
        }
      },
    ),
  );
}
