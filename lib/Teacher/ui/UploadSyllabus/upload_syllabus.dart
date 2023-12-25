// import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:intrack/Teacher/models/upload_syllabus.dart';
import 'package:intrack/widget_methods.dart';

class UploadSyllabus extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  final List subjects;
  UploadSyllabus(
      {Key key, this.userToken, this.classId, this.sectionId, this.subjects})
      : super(key: key);
  @override
  _UploadSyllabusState createState() => _UploadSyllabusState();
}

class _UploadSyllabusState extends State<UploadSyllabus> {
  List _subjects = [];
  String problemList = "";
  TextEditingController descriptionController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentSubject;

  String classId;

  String homework;
  String connection = "Done";

  double cHeight;
  double cWidth;
  final String url = "https://api-dashboard.intrack.in/v1/createSyallabus";
  // String subject;
  var homeworkDate = new DateTime.now().toIso8601String().substring(0, 10);
  String _fileName;
  String _path = '...';
  String _extension;

  String base64Image;
  String fileType;

  File _image;
  var delete = false;
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
    descriptionController.addListener(() {
      setState(() {
        homework = descriptionController.text;
      });
    });
    _subjects = widget.subjects;
    print(classId);
    _currentSubject = widget.subjects.length > 0 ? widget.subjects[0] : null;

    print(widget.subjects);
    print(_currentSubject);
    super.initState();
  }

  void changedDropDownItemSubject(String selectedSubject) {
    print("Selected city $selectedSubject, we are going to refresh the UI");
    setState(() {
      _currentSubject = selectedSubject;
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

  Future _uploadSyllabus() async {
    setState(() {
      connection = "working";
    });

    UploadSyllabusModel data = UploadSyllabusModel(
      classId: widget.classId,
      sectionId: widget.sectionId,
      title: _currentSubject,
      description: descriptionController.text,
      upload: base64Image != null ? base64Image : null,
      fileType: fileType,
      fileName: _fileName,
    );
    UploadSyllabusModelNoAttach data1 = UploadSyllabusModelNoAttach(
      classId: widget.classId,
      sectionId: widget.sectionId,
      title: _currentSubject,
      description: descriptionController.text,
    );
    var body = base64Image != null
        ? uploadSyllabusModelToJson(data)
        : uploadSyllabusModelNoAttachToJson(data1);

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
    print(problemList);
    if (response.statusCode == 200) {
      setState(() {
        descriptionController.clear();
        connection = "Done";
        _fileName = null;
        base64Image = null;
      });
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      // Scaffold.of(context).showSnackBar(snackBar);
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text("Syllabus Uploaded")));
      // scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text('Syllabus Uploaded'),
      //   ),
      // );
    } else {
      setState(() {
        connection = "Done";
        _fileName = null;
        base64Image = null;
      });
    }
  }

  // void _openFileExplorer() async {
  //   try {
  //     _path = await FilePicker.getFilePath(
  //         type: FileType.ANY, fileExtension: _extension);
  //   } on PlatformException catch (e) {
  //     print("Unsupported operation" + e.toString());
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _fileName = _path != null ? _path.split('/').last : '...';
  //     // File f=File(path);
  //     File fl = _path != null ? File(_path) : null;
  //     List<int> imageBytes = _path != null ? fl.readAsBytesSync() : null;
  //     base64Image = _path != null ? base64Encode(imageBytes) : null;

  //     fileType = base64Image != null ? detectMimeType(base64Image) : null;
  //   });
  //   Navigator.pop(context);
  // }

  // Future getImage(context) async {
  //   var image = await ImagePicker.pickImage(
  //     source: ImageSource.camera,
  //     maxHeight: 1080,
  //     maxWidth: 720,
  //     imageQuality: 70,
  //   );

  //   if (image != null) {
  //     setState(() {
  //       fileType = "image";
  //       _fileName = "Image added";
  //       List<int> imageBytes = _path != null ? image.readAsBytesSync() : null;
  //       base64Image = _path != null ? base64Encode(imageBytes) : null;
  //       delete = false;
  //     });

  //     print("_image");
  //     print(_image.toString());
  //     Navigator.pop(context);
  //   }
  // }

  // Future getImageGallery(context) async {
  //   var image = await ImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 1080,
  //     maxWidth: 720,
  //     imageQuality: 70,
  //   );

  //   if (image != null) {
  //     setState(() {
  //       _fileName = "Image added";
  //       List<int> imageBytes = _path != null ? image.readAsBytesSync() : null;
  //       base64Image = _path != null ? base64Encode(imageBytes) : null;
  //       delete = false;
  //       fileType = "image";
  //     });

  //     print("_image");
  //     print(_image.toString());
  //     Navigator.pop(context);
  //   }
  // }

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
                  onTap: () {
                    getImageGallery().then((val) {
                      if (val != null) {
                        setState(() {
                          _fileName = val["imageName"];
                          List<int> imageBytes = _path != null
                              ? val["imageFile"].readAsBytesSync()
                              : null;
                          base64Image =
                              _path != null ? base64Encode(imageBytes) : null;
                          delete = false;
                          fileType = "image";
                        });

                        print("_image");
                        print(_image.toString());
                        Navigator.pop(context);
                      }
                    });
                  }),
              ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () {
                    getImageCamera().then((val) {
                      if (val != null) {
                        setState(() {
                          _fileName = val["imageName"];
                          List<int> imageBytes = _path != null
                              ? val["imageFile"].readAsBytesSync()
                              : null;
                          base64Image =
                              _path != null ? base64Encode(imageBytes) : null;
                          delete = false;
                          fileType = "image";
                        });

                        print("_image");
                        print(_image.toString());
                        Navigator.pop(context);
                      }
                    });
                  }),
              ListTile(
                leading: Icon(Icons.folder_open),
                title: Text('Other File'),
                onTap: () => openFileExplorer().then((val) {
                  if (val != null) {
                    setState(() {
                      _fileName = val["filePath"] != null
                          ? val["filePath"].split('/').last
                          : '...';
                      // File f=File(path);
                      File fl = val["filePath"] != null
                          ? File(val["filePath"])
                          : null;
                      List<int> imageBytes =
                          val["filePath"] != null ? fl.readAsBytesSync() : null;
                      base64Image = val["filePath"] != null
                          ? base64Encode(imageBytes)
                          : null;
                      fileType = base64Image != null
                          ? detectMimeType(base64Image)
                          : null;
                    });
                    Navigator.pop(context);
                  }
                }),
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

    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: _pad,
                    child: Center(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("Select Subject"),
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
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        hintText: "Enter Syllabus",
                      ),
                      // onEditingComplete: () {
                      //   setState(() {});
                      // },
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: cWidth * 0.2, right: cWidth * 0.2),
                    child: MaterialButton(
                      color: Colors.grey[200],
                      child: Text("Add Attachment"),
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                    ),
                  ),
                  _fileName != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              fileType == "other"
                                  ? Text(
                                      _fileName,
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Image Added",
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
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
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Color(0xFFFF6144),
                    height: cHeight * 0.075,
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white, fontSize: cHeight * 0.02),
                    ),
                    disabledColor: Colors.grey,
                    onPressed:
                        descriptionController.text == "" || connection != "Done"
                            ? null
                            : () {
                                showDialogSingleButton(
                                    context,
                                    "Upload Syllabus?",
                                    "You want to upload this syllabus",
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
                  _uploadSyllabus();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
