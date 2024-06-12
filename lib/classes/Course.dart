// ignore: file_names
import 'dart:core';

class Course {
  late String courseId;
  late String schoolName;
  late String deptCode;
  late String courseComment;
  late String prerequisiteLink;
  late String courseNumber;
  late String courseTitle;
  late dynamic sections;

  Course({
    required this.schoolName,
    required this.deptCode,
    required this.courseComment,
    required this.prerequisiteLink,
    required this.courseNumber,
    required this.courseTitle,
    required this.sections,
  });

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'schoolName': schoolName,
        'deptCode': deptCode,
        'courseComment': courseComment,
        'prerequisiteLink': prerequisiteLink,
        'courseNumber': courseNumber,
        'courseTitle': courseTitle,
        'sections': sections,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
      schoolName: json['schoolName'],
      deptCode: json['deptCode'],
      courseComment: json['courseComment'],
      prerequisiteLink: json['prerequisiteLink'],
      courseNumber: json['courseNumber'],
      courseTitle: json['courseTitle'],
      sections: json['sections']);
}
