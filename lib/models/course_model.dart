import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class CourseModel {
  int id;
  String createdBy;
  String title;
  String content;
  String postTime;
  int type;
  LoginUser courseCreateduserInfo;

  CourseModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.content,
    required this.postTime,
    required this.type,
    required this.courseCreateduserInfo,
  });

  factory CourseModel.toMap(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['createdTime']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    return CourseModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      content: json['content'],
      postTime: formattedTime,
      type: json['type'],
      courseCreateduserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}
