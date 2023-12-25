import 'package:flutter/material.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';
import 'package:intrack/Student/ui/ChangePassword/changepasswordpage.dart';
import 'package:intrack/Student/ui/ChangeStudent/change_student.dart';
import 'package:intrack/Student/ui/StudentProfile/edit_student_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intrack/Functions/login_logout/logout.dart';

double cHeight;
double cWidth;

class UserProfile extends StatefulWidget {
  final String userToken;
  final String userId;
  final String studentPic;
  UserProfile({Key key, this.userToken, this.userId, this.studentPic})
      : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userName;
  String userRole;
  String userEmail;
  String url = "https://api-dashboard.intrack.in/v1/parentChangePassword";

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userName = preferences.getString('CurrentUserName');
    userRole = preferences.getString('CurrentUserRole');
    userEmail = preferences.getString('CurrentUserEmail');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
      top: cHeight * 0.01,
      bottom: cHeight * 0.01,
      left: cWidth * 0.04,
      right: cWidth * 0.04,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
          padding: _pad,
          child: FutureBuilder(
              future: getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: _pad,
                                  child: CircleAvatar(
                                    backgroundImage: widget.studentPic != null
                                        ? NetworkImage(widget.studentPic)
                                        : AssetImage("assets/demokid.jpg"),
                                    backgroundColor: Colors.green[400],
                                    radius: cHeight * 0.08,
                                  ),
                                ),
                                Padding(
                                  padding: _pad,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: _pad,
                                          child: Container(
                                            width: cWidth * 0.32,
                                            child: Text(
                                              userName,
                                              style: TextStyle(
                                                  fontSize: cWidth * 0.05,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: _pad,
                                          child: Text(
                                            userRole,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     Padding(
                          //       padding: EdgeInsets.only(
                          //           left: cWidth * 0.04,
                          //           right: cWidth * 0.02,
                          //           top: cHeight * 0.02),
                          //       child: Icon(Icons.phone, color: Colors.grey),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.only(
                          //           left: cWidth * 0.08,
                          //           right: cWidth * 0.02,
                          //           top: cHeight * 0.02),
                          //       child: Text(
                          //         "7363352627",
                          //         style: TextStyle(color: Colors.grey),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: cWidth * 0.04,
                                    right: cWidth * 0.02,
                                    top: cHeight * 0.02),
                                child: Icon(Icons.email, color: Colors.grey),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: cWidth * 0.08,
                                    right: cWidth * 0.02,
                                    top: cHeight * 0.02),
                                child: Text(
                                  userEmail,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: cHeight * 0.02),
                          ),
                          Divider(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: <Widget>[
                          //     Column(
                          //       children: <Widget>[
                          //         Text("Total Attendence",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w600,
                          //                 color:
                          //                     Color(0xFF444B54),
                          //                 fontSize: cWidth * 0.04)),
                          //         Padding(
                          //           padding:
                          //               EdgeInsets.only(top: cHeight * 0.01),
                          //         ),
                          //         Text("82%"),
                          //       ],
                          //     ),
                          //     Container(
                          //       height: cHeight * .05,
                          //       width: cWidth * 0.0005,
                          //       color: Colors.black,
                          //     ),
                          //     Column(
                          //       children: <Widget>[
                          //         Text("Overall Grade",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w600,
                          //                 color:
                          //                     Color.fromRGBO(243, 149, 25, 1.0),
                          //                 fontSize: cWidth * 0.04)),
                          //         Padding(
                          //           padding:
                          //               EdgeInsets.only(top: cHeight * 0.01),
                          //         ),
                          //         Text("B+"),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(top: cHeight * 0.01),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStudentProfile(
                                          userToken: widget.userToken,
                                          userId: widget.userId,
                                          studentPic: widget.studentPic,
                                          // teacher: false,
                                        )),
                              );
                            },
                            leading: Icon(
                              Icons.edit,
                              color: Color(0xFF444B54),
                            ),
                            title: Text("Edit Profile"),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChangeStudent(
                                        userToken: widget.userToken,
                                      )));
                            },
                            leading: Icon(
                              Icons.people,
                              color: Color(0xFF444B54),
                            ),
                            title: Text("Change Student"),
                          ),
                          // ListTile(
                          //   onTap: () {},
                          //   leading: Icon(
                          //     Icons.settings,
                          //     color: Color(0xFF444B54),
                          //   ),
                          //   title: Text("Settings"),
                          // ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePasswordPage(
                                          userToken: widget.userToken,
                                          url: url,
                                          teacher: false,
                                        )),
                              );
                            },
                            leading: Icon(
                              Icons.remove_red_eye,
                              color: Color(0xFF444B54),
                            ),
                            title: Text("Change Password"),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              studentLogout(widget.userToken);
                              logOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                ModalRoute.withName("Logout"),
                              );
                            },
                            leading: Icon(
                              Icons.power_settings_new,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          // Divider()
                        ],
                      ),
                    ],
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              })),
    );
  }
}
