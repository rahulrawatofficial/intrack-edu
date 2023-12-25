import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Student/ui/Dashboard/student_dashboard.dart';
import 'package:intrack/VideoCalling/dlink_calling_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class MpinPage extends StatefulWidget {
  final bool pinExist;
  final int mPin;
  final String userToken;
  final String userId;
  final String parentId;
  final String classId;
  final String sectionId;
  final String studentPic;
  final String studentName;

  // final VoidCallback pinMatch;
  const MpinPage({
    Key key,
    this.pinExist,
    this.mPin,
    this.userToken,
    this.userId,
    this.parentId,
    this.classId,
    this.sectionId,
    this.studentPic,
    this.studentName,
    // this.pinMatch,
  }) : super(key: key);
  @override
  _MpinPageState createState() => _MpinPageState();
}

class _MpinPageState extends State<MpinPage> {
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  bool hidden = true;
  String errorMessage;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Create MPIN
  Future<void> createMpin(BuildContext context, String url, int pin) async {
    Map body = {"mPin": pin};

    final response = await http.post(
      Uri.encodeFull(url),
      body: json.encode(body),
      headers: {
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/json",
      },
    );
    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);
    print("data ${data["message"]}  ${widget.userToken}");
    if (response.statusCode == 200) {
      saveMpin(pin, true).then((v) {
        saveMpin(pin, true).then((v) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDashBoard(
                userToken: widget.userToken,
                userId: widget.userId,
                parentId: widget.parentId,
                classId: widget.classId,
                sectionId: widget.sectionId,
                studentPic: widget.studentPic,
              ),
            ),
            ModalRoute.withName("DashBoard"),
          );
        });
      });
    } else {
      String message = data["message"];
      showDialogSingleButton(context, "Error", message, "Ok");
    }
  }

  //Save Mpin
  Future saveMpin(
    int mPin,
    bool pinExist,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('mPin', mPin);
    await preferences.setBool('pinExist', pinExist);
  }

  @override
  void initState() {
    print("^^^${widget.mPin}^^^");
    print(widget.pinExist);
    print(widget.userId);
    // widget.pinMatch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _showSnackBar(String pin, BuildContext context) {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
            height: 80.0,
            child: Center(
              child: Text(
                'Pin Submitted. Value: $pin',
                style: TextStyle(fontSize: 25.0),
              ),
            )),
        backgroundColor: Colors.greenAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    Icon iconButton =
        hidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility);

    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          print("##${snapshot.data}##");
          if (!snapshot.hasData) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text("Intrack"),
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 60.0,
                          top: 120.0,
                        ),
                        child: Text(
                          widget.mPin != null ? "mPIN" : "Create mPIN",
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 20,
                        ),
                        child: PinPut(
                          isTextObscure: hidden,
                          fieldsCount: 4,
                          // onSubmit: (String pin) => _showSnackBar(pin, context),
                          onSubmit: (String pin) {
                            var i = int.parse(pin);
                            print(i);
                            if (widget.mPin == null) {
                              createMpin(
                                  context,
                                  "https://api-dashboard.intrack.in/v1/createMPin",
                                  i);
                            } else if (i == widget.mPin) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentDashBoard(
                                          userToken: widget.userToken,
                                          userId: widget.userId,
                                          parentId: widget.parentId,
                                          classId: widget.classId,
                                          sectionId: widget.sectionId,
                                          studentPic: widget.studentPic,
                                        )),
                                ModalRoute.withName("DashBoard"),
                              );
                            } else {
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                    'Wrong Pin!',
                                    // style: TextStyle(fontSize: 15.0),
                                  ),
                                  // backgroundColor: Colors.redAccent,
                                ),
                              );
                              // setState(() {
                              //   this.hasError = true;
                              //   print(thisText);
                              // });
                            }
                          },
                          onClear: (String pin) {},
                        ),
                      ),
                      // Visibility(
                      //   child: Text(
                      //     "Wrong PIN!",
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      //   visible: hasError,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: iconButton,
                              onPressed: () {
                                setState(() {
                                  hidden == false
                                      ? hidden = true
                                      : hidden = false;
                                  this.controller.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            studentLogout(widget.userToken);
                            logOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              ModalRoute.withName("Logout"),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.power_settings_new, color: Colors.red),
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return DLinkCallingScreen(
              url: snapshot.data,
              userToken: widget.userToken,
              userId: widget.userId,
              parentId: widget.parentId,
              classId: widget.classId,
              sectionId: widget.sectionId,
              studentPic: widget.studentPic,
              studentName: widget.studentName,
            );
          }
        });
  }
}
