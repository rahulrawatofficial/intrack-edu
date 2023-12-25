import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/Resources/http_requests.dart';
import 'package:intrack/Teacher/models/course_attendance_model.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

class DLinkCallingScreen extends StatefulWidget {
  final String url;
  final String serverUrl;
  final String userToken;
  final String userId;
  final String parentId;
  final String classId;
  final String sectionId;
  final String studentPic;
  final String studentName;
  final String chapterId;
  final String courseId;
  final String liveClassId;
  final String studentId;

  const DLinkCallingScreen(
      {Key key,
      this.url,
      this.userToken,
      this.userId,
      this.parentId,
      this.classId,
      this.sectionId,
      this.studentPic,
      this.studentName,
      this.serverUrl,
      this.chapterId,
      this.courseId,
      this.liveClassId,
      this.studentId})
      : super(key: key);
  @override
  _DLinkCallingScreenState createState() => _DLinkCallingScreenState();
}

class _DLinkCallingScreenState extends State<DLinkCallingScreen> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final subjectText = TextEditingController(text: "Virtual Class");
  final nameText = TextEditingController(text: "User");
  final emailText = TextEditingController(text: "new@email.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String courseAttendanceId;
  String liveClassId;

  @override
  void initState() {
    print(widget.url);
    print("live class id${widget.liveClassId}");
    print(widget.studentId);
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
    if (widget.studentName != null) {
      nameText.text = widget.studentName;
    }
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Call'),
        automaticallyImplyLeading: true,
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back_ios),
        //     onPressed: () {
        //       Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => Provider<DeepLinkBloc>(
        //                   create: (context) => _bloc,
        //                   dispose: (context, bloc) => bloc.dispose(),
        //                   child: MyApp(),
        //                 )),
        //         ModalRoute.withName("DashBoard"),
        //       );
        //     }),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                // TextFormField(
                //   controller: roomText,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Room Name",
                //     // hintText: "Hint: Leave empty for meet.jitsi.si",
                //   ),
                //   validator: (value) {
                //     if (value.length == 0) {
                //       return ('Enter valid room name');
                //     } else {
                //       return null;
                //     }
                //   },
                // ),
                // SizedBox(
                //   height: 16.0,
                // ),
                // TextField(
                //   controller: roomText,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Room",
                //   ),
                // ),
                // SizedBox(
                //   height: 16.0,
                // ),
                // TextField(
                //   controller: subjectText,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Subject",
                //   ),
                // ),
                // SizedBox(
                //   height: 16.0,
                // ),
                TextFormField(
                  controller: nameText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Display Name",
                  ),
                  validator: (value) {
                    if (value.length == 0) {
                      return ('Enter display name');
                    } else {
                      return null;
                    }
                  },
                ),
                // SizedBox(
                //   height: 16.0,
                // ),
                // TextField(
                //   controller: emailText,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Email",
                //   ),
                // ),
                // SizedBox(
                //   height: 16.0,
                // ),
                // TextField(
                //   controller: iosAppBarRGBAColor,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: "AppBar Color(IOS only)",
                //       hintText: "Hint: This HAS to be in HEX RGBA format"),
                // ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Only"),
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Muted"),
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Video Muted"),
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
                Divider(
                  height: 48.0,
                  thickness: 2.0,
                ),
                SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: RaisedButton(
                    onPressed: () {
                      _validate();
                    },
                    child: Text(
                      "Join Meeting",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  Future createAttendance() async {
    CourseAttendanceModel body = CourseAttendanceModel(
      classId: widget.classId,
      date: DateTime.now(),
      studentAttendance: [
        StudentAttendance(
          chapterId: widget.chapterId,
          courseId: widget.courseId,
          liveClassId: widget.liveClassId,
          startTime: DateFormat('h:mm a').format(DateTime.now()),
        )
      ],
      studentId: widget.studentId,
    );
    final response = await ApiBase().post(
        context, "/v1/createCourseAttendance", null, body, widget.userToken);
    if (response.statusCode == 200) {
      var d = json.decode(response.body);
      courseAttendanceId = d["data"]["_id"];
      // liveClassId = d["data"]["studentAttendance"][0]["liveClassId"];
      print("###$d###");
      _joinMeeting();
    }
  }

  Future endAttendance() async {
    var body = {
      "courseAttendanceId": courseAttendanceId,
      "liveClassId": widget.liveClassId,
      "endTime": DateFormat('h:mm a').format(DateTime.now()),
    };
    final response = await ApiBase().put(
        context, "/v1/updateCourseAttendance", null, body, widget.userToken);
    if (response.statusCode == 200) {
      var d = json.decode(response.body);
      print("###$d###");
    }
  }

  _joinMeeting() async {
    String roomName = widget.serverUrl == null
        ? widget.url.split("intrack://deeplink.intrack.in/").last
        : widget.serverUrl.split("https://meet.intrack.in/").last;
    String serverUrl = "https://meet.intrack.in/$roomName";

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      // Map<FeatureFlagEnum, bool> featureFlags =
      // {
      //   FeatureFlagEnum.WELCOME_PAGE_ENABLED : false,
      // };

      // Here is an example, disabling features for each platform
      // if (Platform.isAndroid)
      // {
      //   // Disable ConnectionService usage on Android to avoid issues (see README)
      //   featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      // }
      // else if (Platform.isIOS)
      // {
      //   // Disable PIP on iOS as it looks weird
      //   featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      // }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomName
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        // ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
      // ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
          onConferenceWillJoin: ({message}) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: ({message}) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: ({message}) {
            debugPrint("${options.room} terminated with message: $message");
          },
        ),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    endAttendance();
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      createAttendance();
    }
  }
}
