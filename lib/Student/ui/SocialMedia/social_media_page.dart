import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/social_media_bloc.dart';
import 'package:intrack/Student/models/social_media_model.dart';
import 'package:intrack/Student/models/timetable_model.dart';
import 'package:intrack/Student/blocs/timetable_bloc.dart';
import 'package:intrack/Student/ui/SocialMedia/facebook_page.dart';

class SocialMediaPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  SocialMediaPage({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

// _InternalLinkedHashMap<String, dynamic> jk;
TimeTableModel timeTable;

class _SocialMediaPageState extends State<SocialMediaPage> {
  // final String url = "http://139.59.58.160:8001/v1/studentViewTimeTable";

  @override
  void initState() {
    super.initState();
    print(widget.studentId);
    socialMediaBloc.fetchAllSocialMedia(
      widget.userToken,
      context,
    );
    //print(timeTable.data.id);
    //this._postConnect();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: socialMediaBloc.allSocialMedia,
        builder: (context, AsyncSnapshot<SocialMediaModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.success == true) {
              if (snapshot.data.data.length > 0) {
                return DefaultTabController(
                    length: snapshot.data.data.length,
                    child: Scaffold(
                      appBar: new AppBar(
                        title: new Text("Social Media"),
                        bottom: TabBar(
                          // isScrollable: true,
                          labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          tabs: snapshot.data.data.length > 1
                              ? <Widget>[
                                  Tab(
                                    text: snapshot.data.data[0].type,
                                  ),
                                  Tab(text: snapshot.data.data[1].type)
                                ]
                              : <Widget>[
                                  Tab(
                                    text: snapshot.data.data[0].type,
                                  ),
                                ],
                        ),
                      ),
                      body: TabBarView(
                        children: snapshot.data.data.length > 1
                            ? <Widget>[
                                FacebookPage(
                                  url: snapshot.data.data[0].linkUrl,
                                ),
                                FacebookPage(
                                  url: snapshot.data.data[1].linkUrl,
                                ),
                              ]
                            : <Widget>[
                                FacebookPage(
                                  url: snapshot.data.data[0].linkUrl,
                                ),
                              ],
                      ),
                    ));
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Social Media"),
                  ),
                  body: Center(
                    child: Text("No DATA"),
                  ),
                );
              }
            } else if (snapshot.data.message == "false") {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Social Media"),
                ),
                body: Center(
                  child: Text("No DATA"),
                ),
              );
            }
          } else
            return Scaffold(
              appBar: AppBar(
                title: Text("Social Media"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }
}
