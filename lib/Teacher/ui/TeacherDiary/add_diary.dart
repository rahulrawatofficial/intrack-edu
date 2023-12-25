import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intrack/Teacher/models/students_info_list_model.dart';
import 'package:intrack/Teacher/resources/StudentsInfoList/students_info_list_api.dart';

double cHeight;
double cWidth;

class AddDiary extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  // final studentData;
  AddDiary({
    Key key,
    this.userToken,
    this.classId,
    this.sectionId,
    // this.studentData,
  }) : super(key: key);
  @override
  _AddDiaryState createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  String title;
  String description;
  String studentId;
  String schoolId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController descriptionField = TextEditingController();

  List _students = [];
  List studentsList = List();

  final String url = "https://api-dashboard.intrack.in/v1/createDiary";

  var data;

  List<DropdownMenuItem<String>> _dropDownMenuItemsStudent;
  String _currentStudent;
  StudentsInfoModel studentInfoData = StudentsInfoModel();

  @override
  void initState() {
    StudentsInfoApi()
        .getStudentsInfoList(
            widget.userToken, context, widget.classId, widget.sectionId)
        .then((val) {
      setState(() {
        studentInfoData = val;

        studentId = studentInfoData.data[0].id;
        // print(widget.studentData);
        _dropDownMenuItemsStudent = getDropDownMenuItemsStudent();
        _currentStudent = _dropDownMenuItemsStudent[0].value;
      });
    });
    super.initState();
  }

  void changedDropDownItemStudent(String selectedStudent) {
    var i = _students.indexOf(selectedStudent);
    print("Selected Student $selectedStudent, we are going to refresh the UI");
    setState(() {
      _currentStudent = selectedStudent;
      studentId = studentInfoData.data[i].id;
    });
    print(studentId);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsStudent() {
    for (int i = 0; i < studentInfoData.data.length; i++) {
      _students.add(studentInfoData.data[i].name);
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

  Future _uploadNote() async {
    // setState(() {
    //   problemList.add(homework);
    //   homeworkProblem.clear();
    // });
    Map body = {
      "studentId": studentId,
      "title": descriptionField.text,
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
        backgroundColor: Color(0xFFFF6144),
        title: Text("Upload Note"),
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
                  color: Color(0xFFFF6144),
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
