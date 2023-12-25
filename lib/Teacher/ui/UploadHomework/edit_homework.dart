// import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intrack/Teacher/models/update_homework_model.dart';
import 'dart:convert';

double cHeight;
double cWidth;
final String url = "https://api-dashboard.intrack.in/v1/updateHomework";
var homeworkSubject;
var homeworkDate = new DateTime.now().toIso8601String().substring(0, 10);
String _fileName;
String _path = '...';
String _extension;
bool _hasValidMime = false;
FileType _pickingType;
TextEditingController _controller = new TextEditingController();

String base64Image;

class EditHomework extends StatefulWidget {
  final String userToken;
  final classData;
  final List subjects;
  final String homeworkId;
  final String subjectHomeworkId;
  final String subjectName;
  final String description;
  EditHomework({
    Key key,
    this.userToken,
    this.classData,
    this.subjects,
    this.homeworkId,
    this.subjectName,
    this.description,
    this.subjectHomeworkId,
  }) : super(key: key);
  @override
  _EditHomeworkState createState() => _EditHomeworkState();
}

class _EditHomeworkState extends State<EditHomework> {
  List _subjects = ["English", "Physics", "Chemistry", "Hindi", "Biology"];
  dynamic problems = ["do Your homework given", "do that"];
  String problemList = "";
  TextEditingController homeworkProblem = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _dropDownMenuItemsSubject;
  String _currentSubject = "select Subject";

  String classId;

  String homework;
  String connection = "Done";

  File _image;
  var delete = false;
  var fileName;
  var _imageData;
  String fileType;
  Map signatures = {
    "JVBERi0": "other",
    "iVBORw0KGgo": "image",
    "UEsDBBQ": "other",
    "/": "image",
    "AAABAA": "image",
    "IywiV2hhdC": "other",
    "bmFtZSxl": "other"
  };

  detectMimeType(String b64) {
    for (var s in signatures.keys) {
      if (b64.indexOf(s) == 0) {
        print(signatures["$s"]);
        return signatures["$s"];
      }
    }
  }

  @override
  void initState() {
    homeworkProblem.addListener(() {
      setState(() {
        homework = homeworkProblem.text;
      });
    });
    print(widget.subjects.toString());
    _currentSubject = widget.subjectName;
    homeworkProblem.text = widget.description;
    classId = widget.classData["_id"];
    print(classId);
    // _dropDownMenuItemsSubject = getDropDownMenuItemsSubject();
    // _currentSubject = _dropDownMenuItemsSubject[0].value;
    //File Picker
    // _controller.addListener(() => _extension = _controller.text);
    super.initState();
  }

  void changedDropDownItemSubject(String selectedSubject) {
    print("Selected city $selectedSubject, we are going to refresh the UI");
    setState(() {
      _currentSubject = selectedSubject;
      homeworkSubject = selectedSubject;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsSubject(
      List subjectItems) {
    List<DropdownMenuItem<String>> items = new List();
    for (String sub in subjectItems) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: sub, child: new Text(sub)));
    }
    return items;
  }

  Future _uploadHomework() async {
    setState(() {
      connection = "working";
    });
    setState(() {
      //problemList.add(homework);
      problemList = homework;
      // homeworkProblem.clear();
    });

    Homework work = Homework(
      problems: problemList,
      subjectName: homeworkSubject,
      upload: base64Image != null ? base64Image : "",
      fileType: fileType,
    );
    UpdateHomeworkModel data = UpdateHomeworkModel(
      sectionId: classId,
      homeworkId: widget.homeworkId,
      problems: problemList,
      subjectName: _currentSubject,
      upload: base64Image != null ? base64Image : "",
      subjectHomeWorkId: widget.subjectHomeworkId,
    );
    HomeworkNoAttach work1 = HomeworkNoAttach(
      problems: problemList,
      subjectName: homeworkSubject,
    );
    UpdateHomeworkModelNoAttach data1 = UpdateHomeworkModelNoAttach(
      sectionId: classId,
      homeworkId: widget.homeworkId,
      problems: problemList,
      subjectName: _currentSubject,
      subjectHomeWorkId: widget.subjectHomeworkId,
    );
    var body = base64Image != null
        ? updateHomeworkModelToJson(data)
        : updateHomeworkModelNoAttachToJson(data1);

    print("body $body");
    print("jsonBody ${body.runtimeType}");
    //String jsonHomework = json.encode(body);
    //print("jsonBody ${jsonHomework.runtimeType}");
    final response = await http.put(
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
    print(problemList);
    if (response.statusCode == 200) {
      setState(() {
        connection = "Done";
        _fileName = null;
        base64Image = null;
      });
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      // Scaffold.of(context).showSnackBar(snackBar);
      // Scaffold.of(context)
      //     .showSnackBar(new SnackBar(content: new Text("Homework Uploaded")));
      Navigator.of(context).pop();
    } else {
      setState(() {
        connection = "Done";
      });
    }
  }

  void _openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath(
          type: FileType.ANY, fileExtension: _extension);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
      // File f=File(path);
      File fl = _path != null ? File(_path) : null;
      List<int> imageBytes = _path != null ? fl.readAsBytesSync() : null;
      base64Image = _path != null ? base64Encode(imageBytes) : null;
      fileType = base64Image != null ? detectMimeType(base64Image) : null;
    });
  }

  Future getImage(context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 720,
      imageQuality: 70,
    );

    setState(() {
      _fileName = "Image added";
      List<int> imageBytes = _path != null ? image.readAsBytesSync() : null;
      base64Image = _path != null ? base64Encode(imageBytes) : null;
      delete = false;

      fileType = "image";
    });
    print("_image");
    print(_image.toString());
    Navigator.pop(context);
  }

  Future getImageGallery(context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 720,
      imageQuality: 70,
    );

    setState(() {
      _fileName = "Image added";
      List<int> imageBytes = _path != null ? image.readAsBytesSync() : null;
      base64Image = _path != null ? base64Encode(imageBytes) : null;
      delete = false;
      fileType = "image";
    });
    print("_image");
    print(_image.toString());
    Navigator.pop(context);
  }

  deleteProfileImage(context) {
    setState(() {
      delete = true;
    });
    Navigator.pop(context);
  }

  void _showBottomSheet(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () => getImageGallery(context),
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () => getImage(context),
              ),
              ListTile(
                leading: Icon(Icons.folder_open),
                title: Text('Other File'),
                onTap: () => _openFileExplorer(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.only(
        top: cHeight * 0.02, left: cWidth * 0.04, right: cWidth * 0.04);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Edit Homework"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: _pad,
                    child: Center(
                      child: DropdownButton(
                        isExpanded: true,
                        disabledHint: Text("Select subject"),
                        value: _currentSubject,
                        items: getDropDownMenuItemsSubject(widget.subjects),
                        onChanged: changedDropDownItemSubject,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: cHeight * 0.05,
                        left: cWidth * 0.04,
                        right: cWidth * 0.04),
                    child: TextField(
                      controller: homeworkProblem,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        hintText: "Enter Homework",
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      },
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  MaterialButton(
                    color: Colors.grey[200],
                    child: Text("Add Attachment"),
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                  ),
                  _fileName != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Text(
                                _fileName,
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _fileName = null;
                                    base64Image = null;
                                  });
                                },
                              )
                            ])
                      : Offstage(),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Color(0xFFFF6144),
                      height: cHeight * 0.075,
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white, fontSize: cHeight * 0.02),
                      ),
                      disabledColor: Colors.grey,
                      onPressed:
                          homeworkProblem.text == "" || connection != "Done"
                              ? null
                              : () {
                                  showDialogSingleButton(
                                      context,
                                      "Update Homework?",
                                      "You want to update this homework",
                                      "Cancel",
                                      "Ok");
                                },
                    ),
                  ),
                ],
              )
            ],
          ),
          connection != "Done"
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
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
                  _uploadHomework();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
