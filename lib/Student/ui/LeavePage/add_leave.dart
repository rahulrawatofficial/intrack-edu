import 'package:flutter/material.dart';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intrack/Student/resources/leaves/add_leave_api.dart';
import 'package:intrack/Student/resources/reminder/createReminderApi.dart';

class AddLeave extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String classId;
  final String sectionId;
  AddLeave({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  @override
  _AddLeaveState createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {
  double cHeight;
  double cWidth;

  TextEditingController controller = TextEditingController();
  TextEditingController titleController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDate = new DateTime.now();
  List leaveDates = [];
  // Iterable<DateTime> selectedWeeksDays;
  String displayDate;

  DateTime currentDate = DateTime.now().add(new Duration(days: 1));
  DateTime selected = DateTime.now().add(new Duration(days: 1));

  DateTime _selectedDate1 = DateTime.now().add(new Duration(days: 1));
  DateTime _selectedDate2 = DateTime.now().add(new Duration(days: 1));

  String displayMonth1 = Utils.fullDayFormat(DateTime.now());
  String displayMonth2 = Utils.fullDayFormat(DateTime.now());

  void _launchStartDate() async {
    _selectedDate = _selectedDate1;
    displayMonth1 = await selectDateFromPicker();
    setState(() {
      _selectedDate1 = _selectedDate;
      _selectedDate2 = _selectedDate;
    });
  }

  void _launchEndDate() async {
    _selectedDate = _selectedDate2;
    displayMonth2 = await selectDateFromPicker2();
    setState(() {
      _selectedDate2 = _selectedDate;
    });
  }

  Future<String> selectDateFromPicker() async {
    DateTime _date = DateTime(3050);

    selected = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: currentDate,
        lastDate: _date);

    if (selected != null) {
      _selectedDate = selected;
      displayDate = Utils.fullDayFormat(selected);
    }
    //print(displayMonth);
    displayDate = DateFormat.MMMMEEEEd().format(_selectedDate);
    return displayDate;
  }

  Future<String> selectDateFromPicker2() async {
    DateTime _date = DateTime(3050);

    selected = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _selectedDate1,
        lastDate: _date);

    if (selected != null) {
      _selectedDate = selected;
      displayDate = Utils.fullDayFormat(selected);
    }
    //print(displayMonth);
    displayDate = DateFormat.MMMMEEEEd().format(_selectedDate);
    return displayDate;
  }

  doadd() {
    leaveDates.clear();
    DateTime date = _selectedDate1;
    var difference = _selectedDate2.difference(_selectedDate1).inDays;
    for (int i = 0; i < difference + 1; i++) {
      leaveDates.add(date.add(Duration(days: i)).toString().substring(0, 11));
      print(date);
    }
    addLeave(
      context,
      widget.userToken,
      titleController.text,
      controller.text,
      leaveDates,
      widget.studentId,
      widget.classId,
      widget.sectionId,
    ).then((val) {
      Navigator.of(context).pop();
    });
    print(leaveDates);
    print(_selectedDate1);
    print(_selectedDate2);
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
        left: cWidth * 0.05,
        right: cWidth * 0.05,
        top: cHeight * 0.01,
        bottom: cHeight * 0.01);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Add Leave"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: cHeight * 0.02,
                    left: cWidth * 0.04,
                    right: cWidth * 0.04,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: _launchStartDate,
                          child: Card(
                              elevation: 3.0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: cHeight * 0.04,
                                  bottom: cHeight * 0.04,
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: cWidth * 0.04,
                                          right: cWidth * 0.02),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                        size: cWidth * 0.09,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'From',
                                          style: new TextStyle(
                                            fontSize: cWidth * 0.032,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          // "",
                                          '${_selectedDate1.day} ${DateFormat.MMM().format(_selectedDate1)} ${_selectedDate1.year}',
                                          style: new TextStyle(
                                            fontSize: cWidth * 0.043,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _launchEndDate,
                          child: Card(
                              elevation: 3.0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: cHeight * 0.04,
                                    bottom: cHeight * 0.04),
                                child: new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: cWidth * 0.04,
                                          right: cWidth * 0.02),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                        size: cWidth * 0.09,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'To',
                                          style: new TextStyle(
                                            fontSize: cWidth * 0.032,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          // "",
                                          '${_selectedDate2.day} ${DateFormat.MMM().format(_selectedDate2)} ${_selectedDate2.year}',
                                          style: new TextStyle(
                                            fontSize: cWidth * 0.043,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: _pad,
                  child: TextField(
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    // maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Title",
                    ),
                  ),
                ),
                Padding(
                  padding: _pad,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PhysicalModel(
                  color: Color(0xFF444B54),
                  child: MaterialButton(
                    height: cHeight * 0.075,
                    child: Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.white, fontSize: cWidth * 0.045),
                    ),
                    onPressed: () {
                      doadd();
                      // showDialogSingleButton(
                      //   context,
                      //   "Add Reminder",
                      //   "You want to add this reminder",
                      //   "Cancel",
                      //   "Add",
                      // );
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
                  // _uploadHomework();

                  createReminder(
                    context,
                    widget.userToken,
                    "Add it",
                    controller.text,
                    selected.toString().substring(0, 10),
                  ).then((val) {
                    Navigator.of(context).pop();
                  });
                  Navigator.of(context).pop(context);
                },
              ),
            ],
          );
        });
  }
}
