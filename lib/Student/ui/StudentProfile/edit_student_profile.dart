import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intrack/main.dart';
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class EditStudentProfile extends StatefulWidget {
  final String userToken;
  final String userId;
  final String studentPic;
  EditStudentProfile({Key key, this.userToken, this.userId, this.studentPic})
      : super(key: key);
  @override
  _EditStudentProfileState createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  double cHeight;
  double cWidth;
  TextEditingController fNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController fNoController = TextEditingController();
  TextEditingController motherController = TextEditingController();
  TextEditingController mNoController = TextEditingController();
  TextEditingController presentAController = TextEditingController();
  TextEditingController permanentAController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  // TextEditingController allergyController = TextEditingController();
  TextEditingController medicalController = TextEditingController();
  bool editProfile = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;
  var delete = false;
  var fileName;
  var _imageData;

  @override
  void initState() {
    getStudentInfo();
    super.initState();
  }

  Future getStudentInfo() async {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: "/v1/getParticularStudent",
        queryParameters: {"studentId": widget.userId},
      ),
      headers: {
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    // var data = json.decode(response.body);
    var data = json.decode(response.body);
    print(data['data']);
    setState(() {
      fNameController.text = data['data']['name'];
      emailController.text = data['data']['email'];
      phoneController.text = data['data']['mobile'];
      dobController.text = data['data']['dob'] == null
          ? ""
          : data['data']['dob'].substring(0, 10);
      genderController.text = data['data']['gender'];
      fatherController.text = data['data']['parentId']['fatherName'];
      fNoController.text = data['data']['parentId']['fatherCellNo'];
      motherController.text = data['data']['parentId']['motherName'];
      mNoController.text = data['data']['parentId']['motherCellNo'];
      presentAController.text = data['data']['presentAddress'];
      permanentAController.text = data['data']['permanentAddress'];
      cityController.text = data['data']['city'];
      pincodeController.text = data['data']['pincode'];
      stateController.text = data['data']['state'];
      countryController.text = data['data']['country'];
      heightController.text = data['data']['height'];
      weightController.text = data['data']['weight'];
      bloodController.text = data['data']['bloodGroup'];
      // allergyController.text = data['data']['allergies'];
      medicalController.text = data['data']['medicalNotes'];
    });
  }

  Future updateInfo() async {
    List<int> imageBytes = _image != null ? _image.readAsBytesSync() : null;
    String base64Image = _image != null ? base64Encode(imageBytes) : null;
    final response = await http.put(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: "/v1/updateStudent",
        // queryParameters: {
        //   "studentId": widget.userId,
        // },
      ),
      headers: {
        "authorization": "Bearer " + widget.userToken,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: base64Image != null
          ? {
              "email": emailController.text,
              "name": fNameController.text,
              "studentId": widget.userId,
              "mobile": phoneController.text,
              "fatherCellNo": fNoController.text,
              "motherCellNo": mNoController.text,
              "presentAddress": presentAController.text,
              "permanentAddress": permanentAController.text,
              "city": cityController.text,
              "pincode": pincodeController.text,
              "state": stateController.text,
              "Country": countryController.text,
              "height": heightController.text,
              "weight": weightController.text,
              "bloodGroup": bloodController.text,
              "gender": genderController.text,
              // "allergies": allergyController.text,
              "medicalNotes": medicalController.text,
              "upload": base64Image != null ? base64Image : null,
              "dob": dobController.text,
            }
          : {
              "email": emailController.text,
              "name": fNameController.text,
              "studentId": widget.userId,
              "mobile": phoneController.text,
              "fatherCellNo": fNoController.text,
              "motherCellNo": mNoController.text,
              "presentAddress": presentAController.text,
              "permanentAddress": permanentAController.text,
              "city": cityController.text,
              "pincode": pincodeController.text,
              "state": stateController.text,
              "Country": countryController.text,
              "height": heightController.text,
              "weight": weightController.text,
              "bloodGroup": bloodController.text,
              "gender": genderController.text,
              // "allergies": allergyController.text,
              "medicalNotes": medicalController.text,
              "dob": dobController.text,
            },
    );
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        editProfile = false;
      });
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //   // backgroundColor: Colors.blue,

      //   content: Text("Changes Saved"),
      // ));
      saveImage(data["data"]["profilePicUrl"]).then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
          ModalRoute.withName("DashBoard"),
        );
      });
    }
  }

  Future getImage(context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 720,
      imageQuality: 70,
    );

    setState(() {
      _image = image;
      delete = false;
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
      _image = image;
      delete = false;
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
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Gallery'),
                onTap: () => getImageGallery(context),
              ),
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () => getImage(context),
              ),
            ],
          );
        });
  }

  Future saveImage(String studentPic) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('studentPic', studentPic);
    await preferences.setString('CurrentUserName', fNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                editProfile = true;
              });
            },
          )
        ],
        backgroundColor: Color(0xFF444B54),
        title: Text("Edit Profile"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: cHeight * 0.17,
                  width: cWidth,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Color(0xFF444B54),
                        backgroundImage: widget.studentPic != null &&
                                _image != null
                            ? FileImage(_image)
                            : widget.studentPic != null && _image == null
                                ? NetworkImage(widget.studentPic)
                                : widget.studentPic == null && _image != null
                                    ? FileImage(_image)
                                    : null,
                        radius: cHeight * 0.06,
                        // child: Icon(
                        //   Icons.person,
                        //   color: Colors.white,
                        //   size: cHeight * 0.1,
                        // ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: cHeight * 0.01,
                        ),
                        child: editProfile
                            ? GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context);
                                },
                                child: Text(
                                  "Add photo",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.05),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: fNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email-Id",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefix:
                          Text("(+91) ", style: TextStyle(color: Colors.black)),
                      labelText: "Phone Number",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: dobController,
                          decoration: InputDecoration(
                            labelText: "Date of birth",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: genderController,
                          decoration: InputDecoration(labelText: "Gender"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: false,
                    controller: fatherController,
                    decoration: InputDecoration(
                      labelText: "Father Name",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: false,
                    controller: fNoController,
                    decoration: InputDecoration(
                      prefix:
                          Text("(+91) ", style: TextStyle(color: Colors.black)),
                      labelText: "Father no.",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: false,
                    controller: motherController,
                    decoration: InputDecoration(
                      labelText: "Mother Name",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: false,
                    controller: mNoController,
                    decoration: InputDecoration(
                      prefix:
                          Text("(+91) ", style: TextStyle(color: Colors.black)),
                      labelText: "Mother no.",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: presentAController,
                    decoration: InputDecoration(
                      labelText: "Present Address",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: permanentAController,
                    decoration: InputDecoration(
                      labelText: "Permanent Address",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: cWidth * 0.05),
                      child: Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                            controller: cityController,
                            //controller: fController,
                            enabled: editProfile,
                            decoration: InputDecoration(
                              labelText: "City",
                              border: UnderlineInputBorder(),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: cWidth * 0.05),
                      child: Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: pincodeController,
                          decoration: InputDecoration(
                            labelText: "Pincode",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: cWidth * 0.05),
                      child: Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                            enabled: editProfile,
                            controller: stateController,
                            // controller: fController,
                            // enabled: false,
                            decoration: InputDecoration(
                              labelText: "State",
                              border: UnderlineInputBorder(),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: cWidth * 0.05),
                      child: Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: countryController,
                          decoration: InputDecoration(
                            labelText: "Country",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: cWidth * 0.05,
                    right: cWidth * 0.05,
                    top: cHeight * 0.03,
                    bottom: cHeight * 0.01,
                  ),
                  child: Text(
                    'Medical Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: cHeight * 0.02,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: heightController,
                          decoration: InputDecoration(
                            labelText: "Height",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width: cWidth * 0.4,
                        child: TextFormField(
                          enabled: editProfile,
                          controller: weightController,
                          decoration: InputDecoration(labelText: "Weight"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    enabled: editProfile,
                    controller: bloodController,
                    decoration: InputDecoration(
                      labelText: "Blood Group",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: cWidth * 0.05,
                //     right: cWidth * 0.05,
                //     top: cHeight * 0.01,
                //     bottom: cHeight * 0.005,
                //   ),
                //   child: Text(
                //     'Allergies',
                //     style: TextStyle(
                //         color: Colors.grey,
                //         fontSize: cHeight * 0.018,
                //         fontWeight: FontWeight.w500),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: cWidth * 0.05,
                //       right: cWidth * 0.05,
                //       top: cHeight * 0.01),
                //   child: TextFormField(
                //     maxLines: 3,
                //     enabled: editProfile,
                //     controller: allergyController,
                //     decoration: InputDecoration(
                //       hintText: "Allergies and reactions",
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    left: cWidth * 0.05,
                    right: cWidth * 0.05,
                    top: cHeight * 0.01,
                    bottom: cHeight * 0.005,
                  ),
                  child: Text(
                    'Medical Notes',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: cHeight * 0.018,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: cWidth * 0.05,
                      right: cWidth * 0.05,
                      top: cHeight * 0.01),
                  child: TextFormField(
                    maxLines: 3,
                    enabled: editProfile,
                    controller: medicalController,
                    decoration: InputDecoration(
                      hintText: "Medical Notes (Like hot water till july end)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          editProfile
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: PhysicalModel(
                        color: Color(0xFF444B54),
                        child: MaterialButton(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            updateInfo();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Row(),
        ],
      ),
    );
  }
}
