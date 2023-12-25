import 'dart:convert';

String uploadResultModelToJson(UploadResultModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UploadResultModel {
  String examType;
  String subject;
  String sectionId;
  List<Performance> performance;

  UploadResultModel({
    this.examType,
    this.subject,
    this.sectionId,
    this.performance,
  });

  Map<String, dynamic> toJson() => {
        "examType": examType,
        "subject": subject,
        "sectionId": sectionId,
        "performance":
            new List<dynamic>.from(performance.map((x) => x.toJson())),
      };
}

class Performance {
  String studentId;
  int marksObtained;
  int maximumMarks;
  String grade;
  String subject;

  Performance({
    this.studentId,
    this.marksObtained,
    this.maximumMarks,
    this.grade,
    this.subject,
  });

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "marksObtained": marksObtained,
        "maximumMarks": maximumMarks,
        "grade": grade,
        "subject": subject,
      };
}
