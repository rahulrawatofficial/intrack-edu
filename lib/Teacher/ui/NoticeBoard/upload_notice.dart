// import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:intrack/widget_methods.dart';

double cHeight;
double cWidth;
final String url = "https://api-dashboard.intrack.in/v1/createEvent";
var homeworkSubject;
var homeworkDate = new DateTime.now().toIso8601String().substring(0, 10);
String _fileName;
String _path = '...';
String _extension;
bool _hasValidMime = false;
FileType _pickingType;
TextEditingController _controller = new TextEditingController();
String fileType;

String base64Image;

class UploadNotice extends StatefulWidget {
  final String userToken;
  final String sectionId;
  UploadNotice({Key key, this.userToken, this.sectionId}) : super(key: key);
  @override
  _UploadNoticeState createState() => _UploadNoticeState();
}

class _UploadNoticeState extends State<UploadNotice> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String connection = "Done";
  String description;

  File _image;
  var delete = false;
  var fileName;
  var _imageData;
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
        description = descriptionController.text;
      });
    });
    setState(() {
      _fileName = null;
      base64Image = null;
    });
    super.initState();
  }

  Future _uploadNotice() async {
    setState(() {
      connection = "working";
    });
    var body = base64Image != null
        ? {
            "sectionId": widget.sectionId,
            "title": titleController.text,
            "description": descriptionController.text,
            "upload": base64Image,
            "fileType": fileType,
            "fileName": _fileName
          }
        : {
            "sectionId": widget.sectionId,
            "title": titleController.text,
            "description": descriptionController.text,
          };

    print("body $body");
    print("jsonBody ${body.runtimeType}");
    //String jsonHomework = json.encode(body);
    //print("jsonBody ${jsonHomework.runtimeType}");
    final response = await http.post(
      Uri.encodeFull(url),
      body: json.encode(body),
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
      setState(() {
        connection = "Done";
        _fileName = null;
        base64Image = null;
        titleController.clear();
        descriptionController.clear();
      });
      // problemList.removeLast();
      var convertJsonToData = json.decode(response.body);
      print(convertJsonToData);
      // Scaffold.of(context).showSnackBar(snackBar);
      // Scaffold.of(context)
      //     .showSnackBar(new SnackBar(content: new Text("Homework Uploaded")));
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Notice Uploaded'),
        ),
      );
    } else {
      setState(() {
        connection = "Done";
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Notice not uploaded'),
        ),
      );
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
  //       _fileName = "Image added";
  //       List<int> imageBytes = _path != null ? image.readAsBytesSync() : null;
  //       base64Image = _path != null ? base64Encode(imageBytes) : null;
  //       fileType = "image";
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
  //       fileType = "image";
  //       delete = false;
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
                          ;
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Upload Notice"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: cHeight * 0.05,
                          left: cWidth * 0.04,
                          right: cWidth * 0.04),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          hintText: "Enter Title",
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: cHeight * 0.05,
                        left: cWidth * 0.04,
                        right: cWidth * 0.04,
                        bottom: cHeight * 0.02,
                      ),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          hintText: "Enter Description",
                        ),
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
                      onPressed: descriptionController.text == "" ||
                              connection != "Done" ||
                              titleController.text == ""
                          ? null
                          : () {
                              showDialogSingleButton(
                                  context,
                                  "Upload Notice?",
                                  "You want to upload this notice",
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
                  _uploadNotice();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
