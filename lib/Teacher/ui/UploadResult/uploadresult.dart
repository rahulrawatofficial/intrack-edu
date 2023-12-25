import 'package:flutter/material.dart';
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Teacher/models/upload_result_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

double cHeight;
double cWidth;

class UploadResult extends StatefulWidget {
  final String userToken;
  final studentData;
  final List subjects;
  UploadResult({Key key, this.userToken, this.studentData, this.subjects})
      : super(key: key);
  @override
  _UploadResultState createState() => _UploadResultState();
}

class _UploadResultState extends State<UploadResult> {
  List studentNameList = [];

  final url = "https://api-dashboard.intrack.in/v1/createResult";

  String _groupvalue;

  List<TextEditingController> _controllers = new List();

  List<Performance> workList = [];

  String _currentSubject;

  List<int> marksList = [];

  String examType;
  String grade = "A";

  List examTypeList = [];
  List examTypeIdList = [];
  int examTypeIndex = 0;
  String currentExamType;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future getExamTypeList() async {
    String path = "/v1/getExamsList";
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
      print("!!${response.body}!!");
      var data = json.decode(response.body);
      setState(() {
        for (int i = 0; i < data["data"].length; i++) {
          examTypeList.add(data["data"][i]["examName"]);
          examTypeIdList.add(data["data"][i]["_id"]);
        }
        if (examTypeList.length > 0) {
          currentExamType = examTypeList[0];
        }
      });
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", widget.userToken, "TEACHER");
    }
    // return SectionListModel.fromJson(json.decode(response.body));
  }

  Future getMarksTypeList() async {
    String path = "/v1/getMarkDistributionsList";
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
      print("!!${response.body}!!");
      var data = json.decode(response.body);
      // setState(() {
      //   for (int i = 0; i < data["data"].length; i++) {
      //     examTypeList.add(data["data"][i]["examName"]);
      //     examTypeIdList.add(data["data"][i]["_id"]);
      //   }
      //   if (examTypeList.length > 0) {
      //     currentExamType = examTypeList[0];
      //   }
      // });
    } else if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(
          context, "Error", "Token Expired", "Ok", widget.userToken, "TEACHER");
    }
    // return SectionListModel.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    getExamTypeList();
    // getMarksTypeList();
    for (int i = 0; i < widget.studentData["studentData"].length; i++) {
      studentNameList.add(widget.studentData["studentData"][i]["name"]);
    }
    print(studentNameList);
    _currentSubject = widget.subjects.length > 0 ? widget.subjects[0] : null;
    super.initState();
  }

  void changedDropDownItemSubject(String selectedSubject) {
    print("Selected Student $selectedSubject, we are going to refresh the UI");
    setState(() {
      _currentSubject = selectedSubject;
    });
  }

  void changedDropDownExamType(String selectedExamType) {
    examTypeIndex = examTypeList.indexOf(selectedExamType);
    setState(() {
      currentExamType = selectedExamType;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(List subjectItems) {
    List<DropdownMenuItem<String>> items = new List();
    for (String sub in subjectItems) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: sub, child: new Text(sub)));
    }
    return items;
  }

  Future _uploadResult() async {
    setState(() {
      // problemList.add(homework);
      // homeworkProblem.clear();
    });
    workList.clear();
    for (int i = 0; i < widget.studentData["studentData"].length; i++) {
      var k = int.parse(_controllers[i].text);
      print("k type: ${k.runtimeType}");
      grade = gradeCalculator(int.parse(_controllers[i].text));
      Performance work = Performance(
        grade: grade,
        marksObtained: int.parse(_controllers[i].text),
        maximumMarks: 100,
        studentId: widget.studentData["studentData"][i]["_id"],
        subject: _currentSubject,
      );
      workList.add(work);
    }

    UploadResultModel data = UploadResultModel(
      sectionId: widget.studentData["_id"],
      subject: _currentSubject,
      examType: currentExamType,
      performance: workList,
    );
    var body = uploadResultModelToJson(data);

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
    // print(problemList);
    if (response.statusCode == 200) {
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].clear();
      }
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Marks Uploaded'),
        ),
      );
    }
    if (response.statusCode == 403) {
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
    }
  }

  @override
  Widget build(BuildContext context) {
    void something(String e) {
      setState(() {
        if (e == "FA1") {
          _groupvalue = "FA1";
          examType = "FA1";
        } else if (e == "FA2") {
          _groupvalue = "FA2";
          examType = "FA2";
        } else if (e == "SA1") {
          _groupvalue = "SA1";
          examType = "SA1";
        }
      });
    }

    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.only(
        top: cHeight * 0.02, left: cWidth * 0.04, right: cWidth * 0.04);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Upload Result"),
        backgroundColor: Color(0xFFFF6144),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: _pad,
            child: Center(
                child: Text(
              "SUBJECT",
              style: TextStyle(
                  fontSize: cWidth * 0.055,
                  color: Color(0xFFFF6144),
                  fontWeight: FontWeight.w600),
            )),
          ),
          Padding(
            padding: _pad,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: _currentSubject,
                items: getDropDownMenuItems(widget.subjects),
                onChanged: changedDropDownItemSubject,
                hint: Text("Select Subject"),
              ),
            ),
          ),
          Padding(
            padding: _pad,
            child: Center(
                child: Text(
              "Exam Type",
              style: TextStyle(
                  fontSize: cWidth * 0.055,
                  color: Color(0xFFFF6144),
                  fontWeight: FontWeight.w600),
            )),
          ),
          Padding(
            padding: _pad,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: currentExamType,
                items: getDropDownMenuItems(examTypeList),
                onChanged: changedDropDownExamType,
                hint: Text("Select Exam Type"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: cHeight * 0.02,
                bottom: cHeight * 0.01,
                left: cWidth * 0.04,
                right: cWidth * 0.04),
            child: Container(
              height: cHeight * 0.05,
              color: Color(0xFFFF6144),
              child: Padding(
                padding: EdgeInsets.only(
                    top: cHeight * 0.005,
                    left: cWidth * 0.16,
                    right: cWidth * 0.16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: cWidth * 0.05,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: cWidth * 0.0),
                      child: Text(
                        "Marks",
                        style: TextStyle(
                            fontSize: cWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studentNameList.length,
              itemBuilder: (BuildContext context, int index) {
                _controllers.add(new TextEditingController());
                return Padding(
                  padding: EdgeInsets.only(
                      top: cHeight * 0.005,
                      left: cWidth * 0.2,
                      right: cWidth * 0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        studentNameList[index],
                        style: TextStyle(
                            fontSize: cWidth * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: cHeight * 0.04,
                        width: cWidth * 0.14,
                        child: TextField(
                          controller: _controllers[index],
                          //onChanged: ,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(
                                  left: cWidth * 0.02,
                                  right: cWidth * 0.02,
                                  top: cHeight * 0.007,
                                  bottom: cHeight * 0.007)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
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
                      // print(_controllers[0].text);
                      showDialogSingleButton(context, "Upload Result?",
                          "You want to upload this result", "Cancel", "Ok");
                      // setState(() {
                      //   for (int i = 0; i < studentNameList.length; i++) {
                      //     marksList.add(int.parse(controller[i].text));
                      //   }
                      //   print(marksList);
                      // });
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
                  _uploadResult();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

String gradeCalculator(int number) {
  if (number > 90)
    return "A+";
  else if (number > 80)
    return "A";
  else if (number > 70)
    return "B+";
  else if (number > 60)
    return "B";
  else if (number > 50)
    return "C+";
  else if (number > 40)
    return "C";
  else if (number > 35) return "D";
  return "E";
}
