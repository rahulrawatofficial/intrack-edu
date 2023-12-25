import 'package:flutter/material.dart';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:intrack/Student/resources/reminder/createReminderApi.dart';
import 'package:intrack/Student/resources/reminder/deleteReminderApi.dart';
import 'package:intrack/Student/resources/reminder/updateReminderApi.dart';
import 'package:intrack/Student/ui/Reminders/reminders.dart';

class UpdateReminder extends StatefulWidget {
  final String userToken;
  final String title;
  final String description;
  final String lastDate;
  final String reminderId;
  UpdateReminder({
    Key key,
    this.userToken,
    this.title,
    this.description,
    this.lastDate,
    this.reminderId,
  }) : super(key: key);
  @override
  _UpdateReminderState createState() => _UpdateReminderState();
}

class _UpdateReminderState extends State<UpdateReminder> {
  double cHeight;
  double cWidth;

  TextEditingController controller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  String displayDate;
  DateTime selected = DateTime.now().add(Duration(days: 1));

  DateTime _selectedDate1 = DateTime.now().add(Duration(days: 1));
  DateTime currentDate = DateTime.now().add(Duration(days: 1));
  String displayMonth1;

  void _launchStartDate() async {
    //display = false;

    print("display date 1 $displayDate");
    DateTime _date = DateTime(
      int.parse(
        widget.lastDate.toString().substring(0, 4),
      ),
      int.parse(
        widget.lastDate.toString().substring(5, 7),
      ),
      int.parse(
        widget.lastDate.toString().substring(8, 10),
      ),
    );
    _selectedDate = _date;
    _selectedDate1 = _date;
    selected = _date;
    _selectedDate = _selectedDate1;
    displayMonth1 = await selectDateFromPicker();
    print("display date 2 $displayDate");
    setState(() {
      _selectedDate1 = _selectedDate;
    });
  }

  Future<String> selectDateFromPicker() async {
    DateTime _date = DateTime(3050);

    selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: currentDate,
      lastDate: _date,
    );

    if (selected != null) {
      _selectedDate = selected;
    }
    displayDate = _selectedDate.toString().substring(0, 10);
    return Utils.fullDayFormat(_selectedDate);
  }

  @override
  @override
  void initState() {
    super.initState();
    controller.text = widget.description;

    displayDate = widget.lastDate;
    DateTime _date = DateTime(
      int.parse(
        widget.lastDate.toString().substring(0, 4),
      ),
      int.parse(
        widget.lastDate.toString().substring(5, 7),
      ),
      int.parse(
        widget.lastDate.toString().substring(8, 10),
      ),
    );
    displayMonth1 = Utils.fullDayFormat(_date);
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Update Reminder",
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              size: cHeight * 0.032,
            ),
            onPressed: () {
              return showDialogSingleButtonDelete(
                context,
                "Delete",
                "Do you really want to delete",
                "No",
                "Yes",
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: _pad,
                  child: Container(
                    //color: Colors.lightBlue,
                    child: GestureDetector(
                      onTap: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        _launchStartDate();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: cHeight * 0.02,
                          bottom: cHeight * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                right: cWidth * 0.03,
                              ),
                              child: Icon(
                                Icons.date_range,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              displayMonth1,
                              style: TextStyle(
                                fontSize: cWidth * 0.05,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                child: MaterialButton(
                  height: cHeight * 0.075,
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: cWidth * 0.045,
                    ),
                  ),
                  color: Color(0xFF444B54),
                  onPressed: () {
                    return showDialogSingleButtonUpdate(
                      context,
                      "Update Reminder",
                      "You want to Update this reminder",
                      "Cancel",
                      "Update",
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDialogSingleButtonUpdate(
    BuildContext context,
    String title,
    String message,
    String buttonLabel1,
    String buttonLabel2,
  ) {
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
                  print("display date last $displayDate");
                  Navigator.of(context).pop();
                  // USE UPDATE HERE NOW IT IS NOT WORKING (LENGTH ERROR)
                  updateReminder(
                    context,
                    widget.userToken,
                    "Add it",
                    controller.text,
                    displayDate,
                    widget.reminderId,
                  );

                  Navigator.of(context).pop(context);
                },
              ),
            ],
          );
        });
  }

  void showDialogSingleButtonDelete(
    BuildContext context,
    String title,
    String message,
    String buttonLabel1,
    String buttonLabel2,
  ) {
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
                  Navigator.of(context).pop();
                  deleteReminder(
                    context,
                    widget.userToken,
                    widget.reminderId,
                  );

                  Navigator.of(context).pop(context);
                },
              ),
            ],
          );
        });
  }
}
