import 'package:flutter/material.dart';

import 'package:intrack/Teacher/resources/SectionList/get_section_list.dart';
import 'package:intrack/Teacher/models/get_section_list_model.dart';
import 'package:intrack/Teacher/ui/Dashboard/teacher_dashboard.dart';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class ClassList extends StatefulWidget {
  final String userToken;
  final List classNum;
  final List sectionName;
  ClassList({Key key, this.classNum, this.sectionName, this.userToken})
      : super(key: key);
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  double cHeight;
  double cWidth;

  //To Create Json
  File jsonFile;
  Directory dir;
  String fileName = "myJSONFile.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  GetSectionListApi getSectionListApi = GetSectionListApi();

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
    //print(fileContent);
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    return classListSheet();
  }

  Container classListSheet() {
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
                itemCount: widget.classNum.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(index);
                      writeToFile("selectedIndex", index);
                      // Navigator.pop(
                      //     context,
                      //     MaterialPageRoute(
                      //       maintainState: false,
                      //       builder: (context) => TeacherDashBoard(),
                      //     ));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => TeacherDashBoard(
                                  userToken: widget.userToken,
                                )),
                        ModalRoute.withName("Index selected"),
                      );
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
                                "${widget.classNum[index]} ${widget.sectionName[index]}",
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
}
