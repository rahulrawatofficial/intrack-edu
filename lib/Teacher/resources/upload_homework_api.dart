
class UploadHomeworkApi {
  
}

  // Future _uploadHomework() async {
  //   setState(() {
  //     problemList.add(homeworkProblem.text);
  //     homeworkProblem.clear();
  //   });

  //   Homework work = Homework(
  //     problems: problemList,
  //     subjectName: homeworkSubject,
  //   );
  //   Welcome data = Welcome(
  //     sectionId: "5c6f89e75d93af64132931b1",
  //     date: homeworkDate,
  //     homework: work,
  //   );

  //   // Map<String, Object> body = {
  //   //   "sectionId": "5c6f89e75d93af64132931b1",
  //   //   "date": "2019-01-17",
  //   //   "homework": {
  //   //     "subjectName": "This",
  //   //     "problems": ["do this", "do that"]
  //   //   }
  //   // };
  //   // Map<String, dynamic>
  //   var body = welcomeToJson(data);

  //   print("body $body");
  //   print("jsonBody ${body.runtimeType}");
  //   String jsonHomework = json.encode(body);
  //   print("jsonBody ${jsonHomework.runtimeType}");
  //   final response = await http.post(
  //     Uri.encodeFull(url),
  //     body: jsonHomework,
  //     headers: {
  //       "Accept": "application/json",
  //       "authorization": "Bearer " + widget.userToken,
  //       "Content-Type": "application/json"
  //     },
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //   print(problemList);
  //   if (response.statusCode == 200) {
  //     problemList.removeLast();
  //     var convertJsonToData = json.decode(response.body);
  //     print(convertJsonToData);
  //   }
  //   if (response.statusCode == 403) {
  //     problemList.removeLast();
  //     var convertJsonToData = json.decode(response.body);
  //     print(convertJsonToData);
  //   }
  // }