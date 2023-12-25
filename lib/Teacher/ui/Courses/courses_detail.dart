import 'package:flutter/material.dart';
import 'package:intrack/Resources/http_requests.dart';
import 'package:intrack/Student/models/course_detail_model.dart';
import 'package:intrack/Student/models/timetable_model.dart';
import 'package:intrack/Student/ui/Courses/course_content_detail.dart';
import 'package:intrack/Teacher/ui/Courses/course_content_detail.dart';

class TCourseDetail extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String classId;
  final String studentName;
  TCourseDetail({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
    this.studentName,
  }) : super(key: key);
  @override
  _TCourseDetailState createState() => _TCourseDetailState();
}

class _TCourseDetailState extends State<TCourseDetail> {
  Future<CourseDetailModel> getCourseDetail() async {
    var param = {
      "classId": widget.classId,
      // "studentId": widget.studentId,
    };
    final response = await ApiBase()
        .get(context, "/v1/getCourseesList", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return courseDetailModelFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    print("classId ${widget.classId}");
    print("studentId ${widget.studentId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Courses"),
        ),
        body: FutureBuilder(
            future: getCourseDetail(),
            builder: (context, AsyncSnapshot<CourseDetailModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                            color: Colors.transparent,
                            child: ListTile(
                              trailing: Icon(Icons.arrow_right),
                              title: Text(
                                "${snapshot.data.data[index].courseName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TCourseContentDetail(
                                          userToken: widget.userToken,
                                          studentId: widget.studentId,
                                          classId: widget.classId,
                                          courseId:
                                              snapshot.data.data[index].id,
                                          courseName: snapshot
                                              .data.data[index].courseName,
                                          studentName: widget.studentName,
                                        )));
                              },
                            ));
                      });
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
