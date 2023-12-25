import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/notifications_bloc.dart';
import 'package:intrack/Student/models/notifications_model.dart';

class NotificationsPage extends StatefulWidget {
  final String userToken;
  final String studentId;
  NotificationsPage({Key key, this.userToken, this.studentId})
      : super(key: key);
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  double cHeight;
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      top: cHeight * 0.01,
      bottom: cHeight * 0.01,
    );
    notificationsBloc.fetchAllNotifications(
        context, widget.userToken, widget.studentId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: StreamBuilder(
          stream: notificationsBloc.allNotifications,
          builder: (context, AsyncSnapshot<NotificationsModel> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 4,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: cWidth * 0.03,
                                top: cHeight * 0.01,
                              ),
                              child: Text(
                                snapshot.data.data[index].notification.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: cHeight * 0.027),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: cHeight * 0.025,
                                      left: cWidth * 0.03,
                                      right: cWidth * 0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: cWidth * 0.85,
                                        child: Text(
                                          snapshot.data.data[index].notification
                                              .description,
                                          style: TextStyle(
                                            fontSize: cHeight * 0.018,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: cHeight * 0.01,
                                          bottom: cHeight * 0.01,
                                        ),
                                        child: Text(
                                          "${snapshot.data.data[index].notification.created.toString().substring(0, 10)}, ${snapshot.data.data[index].notification.created.toString().substring(12, 16)}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: _pad,
                                //   child: CircleAvatar(
                                //     radius: cHeight * 0.005,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
