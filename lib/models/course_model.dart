import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class CourseChapterInfo {
  int chapter;
  List<String> content;
  CourseChapterInfo({required this.chapter, required this.content});

  factory CourseChapterInfo.toMap(dynamic json) {
    List<String> contents = (json['content'] as List<dynamic>).map((e) {
      return "$e";
    }).toList();
    return CourseChapterInfo(
      chapter: json['chapter'],
      content: contents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'content': content,
    };
  }
}

class CourseModel {
  int id;
  String createdBy;
  String title;
  int needLevel;
  String content;
  String beforeNeed;
  String prStory;
  List<CourseChapterInfo> chapterList;
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
    required this.prStory,
    required this.chapterList,
    required this.courseLearningSkills,
    required this.postTime,
    required this.type,
    required this.isPublic,
    required this.courseCreateduserInfo,
  });

  factory CourseModel.toMap(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['createdTime']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy/MM/dd").format(dateTime.toLocal());

    List<String> courseLearningSkillList = (json['courseLearningkillList'] as List<dynamic>).map((e) {
      return e as String;
    }).toList();

    List<CourseChapterInfo> chapterList = (json['courseChapters'] as List<dynamic>).map((e) {
      return CourseChapterInfo.toMap(e);
    }).toList();

    return CourseModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      needLevel: json['needLevel'],
      content: json['content'],
      beforeNeed: json['beforeNeed'] ?? "none",
      prStory: json['prStory'] ?? "",
      chapterList: chapterList,
      courseLearningSkills: courseLearningSkillList,
      postTime: formattedTime,
      type: json['type'],
      isPublic: json['isPublic'],
      courseCreateduserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}

class CourseCreateModel {
  String createdBy;
  String title;
  int needLevel;
  String content;
  String beforeNeed;
  String prStory;
  List<CourseChapterInfo> chapterList;
  List<String> courseLearningSkills;
  int type;
  bool isPublic;

  CourseCreateModel({
    required this.createdBy,
    required this.title,
    required this.needLevel,
    required this.content,
    required this.beforeNeed,
    required this.prStory,
    required this.chapterList,
    required this.courseLearningSkills,
    required this.type,
    required this.isPublic,
  });

  String courseCreatetoJson() {
    String returnString = jsonEncode({
      'createdBy': createdBy,
      'title': title,
      'needLevel': needLevel,
      'content': content,
      'beforeNeed': beforeNeed,
      'prStory': prStory,
      'courseChapters': chapterList.map((chapter) => chapter.toJson()).toList(),
      'learningkillList': courseLearningSkills,
      'type': type,
      'isPublic': isPublic,
    });

    return returnString;
  }
}
