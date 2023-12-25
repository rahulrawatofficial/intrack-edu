import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

class CallingScreen extends StatefulWidget {
  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "Virtual Class");
  final nameText = TextEditingController(text: "User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Call'),
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
                TextFormField(
                  controller: serverText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Server URL",
                    // hintText: "Hint: Leave empty for meet.jitsi.si",
                  ),
                  validator: (value) {
                    if (value.length == 0 ||
                        !serverText.text.contains("https://meet.intrack.in")) {
                      return ('Enter valid url');
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
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
                      // _joinMeeting();
                      // String serverUrl = serverText.text.split("https://meet.intrack.in/").first==
                      //     ? null
                      //     : serverText.text;
                      print(
                          serverText.text.contains("https://meet.intrack.in"));
                    },
                    child: Text(
                      "Join Meeting",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
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

  _joinMeeting() async {
    String serverUrl = serverText.text;
    String roomName = serverText.text.split("https://meet.intrack.in/").last;
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
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
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
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _joinMeeting();
    }
  }
}
