import 'package:flutter/material.dart';
import 'package:intrack/ForceUpdate/force_update_alert.dart';

class ForcaUpdateScreen extends StatefulWidget {
  @override
  _ForcaUpdateScreenState createState() => _ForcaUpdateScreenState();
}

class _ForcaUpdateScreenState extends State<ForcaUpdateScreen> {
  @override
  void initState() {
    super.initState();
    showVersionDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/launch_image.jpg"), // <-- BACKGROUND IMAGE
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  // _showssDialog() async {
  //   await Future.delayed(Duration(milliseconds: 50));
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return new Container(child: new Text('foo'));
  //       });
  // }
}
