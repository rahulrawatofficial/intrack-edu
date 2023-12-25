import 'package:intrack/Teacher/models/get_students_list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentsListApi {
  Future<StudentsListModel> getStudentList(String userToken) async {
    //final url = "http://192.168.4.226:8001/v1/studentDisplayHomework";
    String path = "/v1/sectionStudentsList";
    Map<String, String> params = {'sectionId': '5c6f89e75d93af64132931b1'};

    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
        queryParameters: params,
      ),
      // Uri.encodeFull(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + userToken
      },
    );
    print("get Student List response: ${response.statusCode}");

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return StudentsListModel.fromJson(json.decode(response.body));
    }

    // var convertDataToJson = json.decode(response.body);
    // data = convertDataToJson['data'];
    // print(data);
    // print("hello");

    // //studentIdList.removeRange(0, studentIdList.length);
    // attendanceData?.removeRange(0, attendanceData.length);
    // //studentData.remove("studentId");
    // //studentData.remove("isPresent");

    // for (int i = 0; i < data['students'].length; i++) {
    //   //studentIdList.add(data['students'][i]['_id']);
    //   studentData = {
    //     "studentId": data['students'][i]['_id'],
    //     "isPresent": studentAttendanceBool[i]
    //   };
    //   attendanceData.add(studentData);
    // }

    // print(attendanceData);
  }
}
