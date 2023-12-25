import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Functions/error.dart';
import 'package:intrack/Teacher/models/upload_notification_model.dart';

double cHeight;
double cWidth;

class UploadNotification extends StatefulWidget {
  final String userToken;
  final studentData;
  UploadNotification({Key key, this.userToken, this.studentData})
      : super(key: key);
  @override
  _UploadNotificationState createState() => _UploadNotificationState();
}

class _UploadNotificationState extends State<UploadNotification> {
  String title;
  String description;
  List<String> sectionId = [];
  List<String> studentId = [];
  String schoolId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleField = TextEditingController();
  TextEditingController descriptionField = TextEditingController();

  List _students = [];
  List studentsList = List();

  List<String> studentF = ["5c6f8acc5d93af64132931b3"];
  List<String> sectionF = ["5c6f89e75d93af64132931b1"];

  final String url = "https://api-dashboard.intrack.in/v1/createNotification";

  var data;

  List<DropdownMenuItem<String>> _dropDownMenuItemsStudent;
  String _currentStudent;

  @override
  void initState() {
    sectionId.add(widget.studentData["_id"]);
    studentId.add(widget.studentData["studentData"][0]["_id"]);
    print(sectionId);
    print(widget.studentData);
    _dropDownMenuItemsStudent = getDropDownMenuItemsStudent();
    _currentStudent = _dropDownMenuItemsStudent[0].value;
    super.initState();
  }

  void changedDropDownItemStudent(String selectedStudent) {
    studentId.clear();
    var i = _students.indexOf(selectedStudent);
    print("Selected Student $selectedStudent, we are going to refresh the UI");
    setState(() {
      _currentStudent = selectedStudent;
      studentId.add(widget.studentData["studentData"][i]["_id"]);
    });
    print(studentId);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsStudent() {
    for (int i = 0; i < widget.studentData["studentData"].length; i++) {
      _students.add(widget.studentData["studentData"][i]["name"]);
    }

    List<DropdownMenuItem<String>> items = new List();
    for (String students in _students) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this

      items.add(
          new DropdownMenuItem(value: students, child: new Text(students)));
    }
    return items;
  }

  Future _uploadNotification() async {
    // setState(() {
    //   problemList.add(homework);
    //   homeworkProblem.clear();
    // });
    UploadNotificationModel data = UploadNotificationModel(
      title: titleField.text,
      description: descriptionField.text,
      studentId: studentId,
      sectionId: sectionId,
      schoolId: "5c4ea818a2fa712f2dd60521",
    );
    var body = uploadNotificationModelToJson(data);

    print("body $body");
    print("jsonBody ${body.runtimeType}");
    //String jsonHomework = json.encode(body);
    //print("jsonBody ${jsonHomework.runtimeType}");
    final response = await http.post(
      Uri.encodeFull(url),
      body: body,
      headers: {
        "Accept": "application/json",
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(response.body);
    //print(problemList);
    if (response.statusCode == 200) {
      //problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Notification Uploaded'),
        ),
      );
    }
    if (response.statusCode == 403) {
      //problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.only(
        top: cHeight * 0.02, left: cWidth * 0.04, right: cWidth * 0.04);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text("Upload Notification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                  padding: _pad,
                  child: Center(
                    child: DropdownButton(
                      isExpanded: true,
                      elevation: 5,
                      disabledHint: Center(child: Text("Class")),
                      value: _currentStudent,
                      items: _dropDownMenuItemsStudent,
                      onChanged: changedDropDownItemStudent,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: cHeight * 0.1,
                    left: cWidth * 0.04,
                    right: cWidth * 0.04),
                child: TextField(
                  controller: titleField,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    hintText: "Title",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: cHeight * 0.03,
                    left: cWidth * 0.04,
                    right: cWidth * 0.04),
                child: TextField(
                  controller: descriptionField,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    hintText: "Description",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PhysicalModel(
                  color: Colors.green[500],
                  child: MaterialButton(
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white, fontSize: cWidth * 0.04),
                    ),
                    onPressed: () {
                      showDialogSingleButton(
                          context,
                          "Upload Notification?",
                          "You want to upload this notification",
                          "Cancel",
                          "Ok");
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
                  _uploadNotification();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
