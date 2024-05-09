import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class CourseModel {
  int id;
  String createdBy;
  String title;
  int needLevel;
  String content;
  String beforeNeed;
  List<String> courseTagsSkillList;
  List<String> courseLearningSkills;
  String postTime;
  int type;
  bool isPublic;
  LoginUser courseCreateduserInfo;

  CourseModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.needLevel,
    required this.content,
    required this.beforeNeed,
    required this.courseTagsSkillList,
    required this.courseLearningSkills,
    required this.postTime,
    required this.type,
    required this.isPublic,
    required this.courseCreateduserInfo,
  });

  factory CourseModel.toMap(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['createdTime']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    List<String> courseTagsSkillList = (json['courseTagsSkillList'] as List<dynamic>).map((e) {
      return e as String;
    }).toList();

    List<String> courseLearningSkillList = (json['courseLearningkillList'] as List<dynamic>).map((e) {
      return e as String;
    }).toList();

    return CourseModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      needLevel: json['needLevel'],
      content: json['content'],
      beforeNeed: json['beforeNeed'] ?? "none",
      courseTagsSkillList: courseTagsSkillList,
      courseLearningSkills: courseLearningSkillList,
      postTime: formattedTime,
      type: json['type'],
      isPublic: json['isPublic'],
      courseCreateduserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}
