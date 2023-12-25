import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Teacher/models/students_info_list_model.dart';

class ParticularStudentInfo extends StatefulWidget {
  final StudentsDatum studentInfoData;
  ParticularStudentInfo({
    Key key,
    this.studentInfoData,
  }) : super(key: key);
  @override
  _ParticularStudentInfoState createState() => _ParticularStudentInfoState();
}

class _ParticularStudentInfoState extends State<ParticularStudentInfo> {
  double cHeight;
  double cWidth;

  List<String> fields = [
    "E-mail",
    "Date of Birth",
    "City",
    "Present Address",
    "Mobile No.",
    "Father Name",
    "Father's Mobile",
    "Mother Name",
    "Mother's Mobile"
  ];

  @override
  void initState() {
    print(widget.studentInfoData.profilePicUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: cHeight * 0.25,
            width: cWidth,
            color: Colors.grey[300],
            child: Center(
              child: CircleAvatar(
                radius: cHeight * 0.06,
                backgroundImage: widget.studentInfoData.profilePicUrl != null
                    ? NetworkImage(widget.studentInfoData.profilePicUrl)
                    : null,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'E-mail',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          width: cWidth * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("${widget.studentInfoData.email}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'City',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.studentInfoData.city),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.studentInfoData.mobile}"),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Present Address',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          // height: cHeight * 0.02,
                          width: cWidth * 0.5,
                          child: Text(
                            widget.studentInfoData.presentAddress,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Father Name",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.studentInfoData.parentId.fatherName}"),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Father's Mobile",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.studentInfoData.parentId.fatherCellNo}"),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Mother Name',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.studentInfoData.parentId.motherName}"),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Mother's Mobile",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.studentInfoData.parentId.motherCellNo}"),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ExpansionTile(
                    title: new Text(
                      "Medical Information",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                    "${widget.studentInfoData.dob.toString().substring(0, 11)}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Blood Group',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text("${widget.studentInfoData.bloodGroup}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text("${widget.studentInfoData.height}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text("${widget.studentInfoData.weight}"),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(20.0),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Text(
                          //         'Allergies',
                          //         style: TextStyle(
                          //           color: Colors.grey,
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.only(top: cHeight * 0.01),
                          //         child: Text(
                          //             "${widget.studentInfoData.medicalNotes}"),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Medical Note',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: cHeight * 0.01),
                                  child: Text(
                                      "${widget.studentInfoData.medicalNotes}"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
