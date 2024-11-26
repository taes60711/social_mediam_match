import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/user_model.dart';

class CourseChapterInfo {
  int chapter;
  String chapterName;
  TextEditingController? chapterNameEditController;
  List<String> content;
  CourseChapterInfo({required this.chapter, required this.chapterName, this.chapterNameEditController, required this.content});

  factory CourseChapterInfo.toMap(dynamic json) {
    List<String> contents = (json['content'] as List<dynamic>).map((e) {
      return "$e";
    }).toList();
    return CourseChapterInfo(
      chapter: json['chapter'],
      chapterName: json['chapterName'] ?? "",
      content: contents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'chapterName': chapterName,
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
  String signUpStatus;
  ProfileData courseCreateduserInfo;

  CourseModel({
    this.id = -1,
    this.createdBy = "",
    this.title = "",
    this.needLevel = -1,
    this.content = "",
    this.beforeNeed = "",
    this.prStory = "",
    this.chapterList = const [],
    this.courseLearningSkills = const [],
    this.postTime = "yyyy-MM-dd HH:mm:ss",
    this.type = -1,
    this.isPublic = false,
    //none added signing
    this.signUpStatus = "",
    required this.courseCreateduserInfo,
  });

  factory CourseModel.toMap(dynamic json) {
    // DateTime dateUtc = DateTime.parse(json['createdTime']).toUtc();
    // DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    // String formattedTime = DateFormat("yyyy/MM/dd").format(dateTime.toLocal());

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
      postTime: json['createdTime'] ?? "",
      type: json['type'],
      isPublic: json['isPublic'],
      signUpStatus: json['signUpStatus'],
      courseCreateduserInfo: ProfileData.toModel(json['user']),
    );
  }

  CourseModel copyWith({CourseModel? data}) {
    return CourseModel(
      id: data?.id ?? id,
      createdBy: data?.createdBy ?? createdBy,
      title: data?.title ?? title,
      needLevel: data?.needLevel ?? needLevel,
      content: data?.content ?? content,
      beforeNeed: data?.beforeNeed ?? beforeNeed,
      prStory: data?.prStory ?? prStory,
      chapterList: data?.chapterList ?? chapterList,
      courseLearningSkills: data?.courseLearningSkills ?? courseLearningSkills,
      postTime: data?.postTime ?? postTime,
      type: data?.type ?? type,
      isPublic: data?.isPublic ?? isPublic,
      signUpStatus: data?.signUpStatus ?? signUpStatus,
      courseCreateduserInfo: data?.courseCreateduserInfo ?? courseCreateduserInfo,
    );
  }
}

class AddedCourseMemberModel {
  int courseId;
  String memberUid;
  ProfileData userData;
  int status;

  AddedCourseMemberModel({
    required this.courseId,
    required this.memberUid,
    required this.userData,
    required this.status,
  });

  factory AddedCourseMemberModel.toMap(dynamic json) {
    return AddedCourseMemberModel(
      courseId: json['courseId'],
      memberUid: json['memberUid'],
      userData: ProfileData.toModel(json['userDTO']),
      status: json['status'],
    );
  }
}
