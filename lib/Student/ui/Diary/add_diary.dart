import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Functions/error.dart';
import 'package:intrack/Teacher/models/upload_notification_model.dart';

double cHeight;
double cWidth;

class AddDiary extends StatefulWidget {
  final String userToken;
  final String studentId;
  AddDiary({Key key, this.userToken, this.studentId}) : super(key: key);
  @override
  _AddDiaryState createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  String title;
  String description;
  String teacherId;
  String schoolId;
  String studentId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController descriptionField = TextEditingController();

  List _teachers = [];
  // List studentsList = List();

  final String url = "https://api-dashboard.intrack.in/v1/createDiaryByStudent";

  var data;
  List teachersList = List();

  List<DropdownMenuItem<String>> _dropDownMenuItemsTeacher;
  String _currentTeacher;
  String path = "/v1/getTeachersList";

  Future getTeacherList() async {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
        // queryParameters: {
        //   "studentId": widget.studentId,
        // }
      ),
      headers: {"authorization": "Bearer " + widget.userToken},
    );
    data = json.decode(response.body);
    print(data);
    setState(() {
      teachersList.clear();
      for (int i = 0; i < data["data"].length; i++) {
        teachersList.add(data['data'][i]['name']);
      }
      teacherId = data["data"][0]["_id"];
      print(teachersList);
      _dropDownMenuItemsTeacher = getDropDownMenuItemsTeacher();
      _currentTeacher = _dropDownMenuItemsTeacher[0].value;
    });
  }

  @override
  void initState() {
    // studentId = widget.studentData["studentData"][0]["_id"];
    // print(widget.studentData);
    // _dropDownMenuItemsStudent = getDropDownMenuItemsStudent();
    // _currentStudent = _dropDownMenuItemsStudent[0].value;
    getTeacherList();
    super.initState();
  }

  void changedDropDownItemTeacher(String selectedStudent) {
    var i = teachersList.indexOf(selectedStudent);
    print("Selected Student $selectedStudent, we are going to refresh the UI");
    setState(() {
      _currentTeacher = selectedStudent;
      teacherId = data["data"][i]["_id"];
    });
    print(teacherId);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsTeacher() {
    // for (int i = 0; i < widget.studentData["studentData"].length; i++) {
    //   _students.add(widget.studentData["studentData"][i]["name"]);
    // }

    List<DropdownMenuItem<String>> items = new List();
    for (String teachers in teachersList) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this

      items.add(
          new DropdownMenuItem(value: teachers, child: new Text(teachers)));
    }
    return items;
  }

  Future _uploadNote() async {
    // setState(() {
    //   problemList.add(homework);
    //   homeworkProblem.clear();
    // });
    Map body = {
      "teacherId": teacherId,
      "title": descriptionField.text,
      "studentId": widget.studentId,
    };

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
      },
    );
    print(response.statusCode);
    print(response.body);
    //print(problemList);
    if (response.statusCode == 200) {
      //problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      descriptionField.clear();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Note Uploaded'),
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
        title: Text("Upload Note"),
      ),
      body: data != null
          ? Column(
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
                            value: _currentTeacher,
                            items: _dropDownMenuItemsTeacher,
                            onChanged: changedDropDownItemTeacher,
                          ),
                        )),
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
                          hintText: "Add Note",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PhysicalModel(
                        color: Color(0xFF444B54),
                        child: MaterialButton(
                          child: Text(
                            "Upload",
                            style: TextStyle(
                                color: Colors.white, fontSize: cWidth * 0.04),
                          ),
                          onPressed: () {
                            showDialogSingleButton(context, "Upload Note?",
                                "You want to upload this note", "Cancel", "Ok");
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
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
                  _uploadNote();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
