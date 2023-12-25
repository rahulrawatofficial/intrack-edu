import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/models/upload_attendance_model.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Teacher/resources/StudentsInfoList/students_info_list_api.dart';

class AttendanceList extends StatefulWidget {
  final String userToken;
  // final classData;
  final classId;
  final sectionId;
  AttendanceList({
    Key key,
    this.userToken,
    // this.classData,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  var attendanceDate = new DateTime.now().toIso8601String().substring(0, 10);
  List<String> studentIdList = List();
  List<bool> studentAttendanceBool = List.filled(50, true);

  List<Map<String, dynamic>> attendanceData = List();
  Map<String, dynamic> studentData = Map();

  double cHeight;
  double cWidth;
  TextEditingController controller = new TextEditingController();
  String filter;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  StudentsInfoModel studentInfoData = StudentsInfoModel();

  @override
  void initState() {
    super.initState();

    // print(widget.classData['studentData'].length);
    StudentsInfoApi()
        .getStudentsInfoList(
            widget.userToken, context, widget.classId, widget.sectionId)
        .then((val) {
      setState(() {
        studentInfoData = val;
      });
    });

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  //Upload Attendence
  Future<void> _uploadAttendence() async {
    print(attendanceData);
    List<Student> newstudent = List.generate(
      attendanceData.length,
      (index) => Student(
        isPresent: attendanceData[index]["isPresent"],
        studentId: attendanceData[index]["studentId"],
      ),
    );
    UploadAttendanceModel data = UploadAttendanceModel(
      sectionId: widget.sectionId,
      date: attendanceDate,
      students: newstudent,
    );
    print("ldata: $data");
    var body = uploadAttendanceModelToJson(data);
    print("body: $body");
    final url = "https://api-dashboard.intrack.in/v1/createAttendance";
    final response = await http.post(
      Uri.encodeFull(url),
      body: body,
      headers: {
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/json"
      },
    );
    print("upload response: ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text("Attendance Uploaded")));
    } else if (response.statusCode == 403) {
      _updateAttendence();
    }
  }

  //Update Attendence
  Future<void> _updateAttendence() async {
    print(attendanceData);
    List<Student> newstudent = List.generate(
      attendanceData.length,
      (index) => Student(
        isPresent: attendanceData[index]["isPresent"],
        studentId: attendanceData[index]["studentId"],
      ),
    );
    UploadAttendanceModel data = UploadAttendanceModel(
      sectionId: widget.sectionId,
      date: attendanceDate,
      students: newstudent,
    );
    print("ldata: $data");
    var body = uploadAttendanceModelToJson(data);
    print("body: $body");
    final url = "https://api-dashboard.intrack.in/v1/updateAttendance";
    final response = await http.put(
      Uri.encodeFull(url),
      body: body,
      headers: {
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/json"
      },
    );
    print("upload response: ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      // scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text('Attendance Updated'),
      //   ),
      // );
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text("Attendance Updated")));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (studentInfoData.data != null) {
      attendanceData?.removeRange(0, attendanceData.length);

      for (int i = 0; i < studentInfoData.data.length; i++) {
        studentData = {
          "studentId": studentInfoData.data[i].id,
          "isPresent": studentAttendanceBool[i]
        };
        attendanceData.add(studentData);
      }

      print(attendanceData);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(cWidth * 0.04),
            child: TextField(
              cursorColor: Color(0xFFFF6144),
              decoration: InputDecoration(
                  hintText: "Search Student",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF6144))),
                  contentPadding: EdgeInsets.all(cWidth * 0.05),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFF6144),
                  )),
              controller: controller,
            ),
          ),
          Container(
            color: Color(0xFFFF6144),
            height: cHeight * 0.06,
            width: cWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: cWidth * 0.04),
                      child: Text(
                        "Roll",
                        style: TextStyle(
                            fontSize: cHeight * 0.022,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: cWidth * 0.175),
                      child: Text(
                        "Name",
                        style: TextStyle(
                            fontSize: cHeight * 0.022,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: cWidth * 0.085),
                  child: Text(
                    "P/A",
                    style: TextStyle(
                        fontSize: cHeight * 0.022,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studentInfoData.data.length == null
                  ? 0
                  : studentInfoData.data.length,
              itemBuilder: (BuildContext context, int index) {
                return filter == null || filter == ""
                    ? new Padding(
                        padding: EdgeInsets.only(
                            top: cHeight * 0.01,
                            left: cWidth * 0.03,
                            right: cWidth * 0.03),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: cWidth * 0.02),
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            " ${index + 1}.  ",
                                            style: TextStyle(
                                                fontSize: cWidth * 0.045),
                                          ),
                                          index < 9 ? Text(" ") : Text(""),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: cWidth * 0.06,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: cHeight * 0.02,
                                                  backgroundColor:
                                                      Color(0xFFFF6144),
                                                  backgroundImage: studentInfoData
                                                              .data[index]
                                                              .profilePicUrl !=
                                                          null
                                                      ? NetworkImage(
                                                          studentInfoData
                                                              .data[index]
                                                              .profilePicUrl)
                                                      : null,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: cWidth * 0.02,
                                                  ),
                                                  child: Text(
                                                      studentInfoData
                                                          .data[index].name,
                                                      style: TextStyle(
                                                          fontSize:
                                                              cWidth * 0.045)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: cWidth * 0.035),
                                    child: Checkbox(
                                      activeColor: Color(0xFFFF6144),
                                      value: studentAttendanceBool[index],
                                      onChanged: (bool change) {
                                        setState(() {
                                          studentAttendanceBool[index] = change;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      )
                    : studentInfoData.data[index].name
                            .toLowerCase()
                            .contains(filter.toLowerCase())
                        ? new Padding(
                            padding: EdgeInsets.only(
                                top: cHeight * 0.01,
                                left: cWidth * 0.03,
                                right: cWidth * 0.05),
                            child: Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: cWidth * 0.02),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                " ${index + 1}.  ",
                                                style: TextStyle(
                                                  fontSize: cWidth * 0.045,
                                                ),
                                              ),
                                              index < 9 ? Text(" ") : Text(""),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: cWidth * 0.06,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: cHeight * 0.02,
                                                      backgroundColor:
                                                          Colors.green,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              studentInfoData
                                                                  .data[index]
                                                                  .profilePicUrl),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: cWidth * 0.02,
                                                      ),
                                                      child: Text(
                                                          studentInfoData
                                                              .data[index].name,
                                                          style: TextStyle(
                                                            fontSize:
                                                                cWidth * 0.045,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: cWidth * 0.035),
                                        child: Checkbox(
                                          activeColor: Color(0xFFFF6144),
                                          value: studentAttendanceBool[index],
                                          onChanged: (bool change) {
                                            setState(() {
                                              studentAttendanceBool[index] =
                                                  change;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          )
                        : new Container();
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PhysicalModel(
                  color: Color(0xFFFF6144),
                  child: MaterialButton(
                    onPressed: () {
                      showDialogSingleButton(context, "Upload Attendance?",
                          "You want to upload this attendance", "Cancel", "Ok");
                    },
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white, fontSize: cHeight * 0.02),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void showDialogSingleButton(BuildContext context, String title,
      String message, String buttonLabel1, String buttonLabel2) {
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
                child: new Text(buttonLabel1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel2),
                onPressed: () {
                  _uploadAttendence();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
