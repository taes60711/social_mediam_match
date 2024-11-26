import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:social_mediam_match/models/user_model.dart';

class PostBoard {
  int id;
  int type;
  String name;
  PostBoard({this.id = 0, this.type = 0, this.name = "chat"});

  factory PostBoard.toMap(dynamic json) {
    return PostBoard(
      id: json['id'],
      type: json['type'],
      name: json['name'],
    );
  }
}

class PostModel {
  int id;
  String createdBy;
  String title;
  String mainMessage;
  String postTime;
  int viewed;
  int good;
  int type;
  int commentCount;
  ProfileData postUserInfo;
  PostModel({
    this.id = -1,
    this.createdBy = "",
    this.title = "",
    this.mainMessage = "",
    this.postTime = "",
    this.viewed = 0,
    this.good = 0,
    this.type = 0,
    this.commentCount = 0,
    ProfileData? postUserInfo,
  }) : postUserInfo = postUserInfo ?? ProfileData();

  factory PostModel.toMap(dynamic json) {
    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      mainMessage: json['mainMessage'],
      viewed: json['viewed'],
      good: json['good'],
      type: json['type'],
      commentCount: json['count'],
      postTime: json['postTime'],
      postUserInfo: ProfileData.toModel(json['user']),
    );
  }

  factory PostModel.myPostToMap(dynamic json) {
    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      mainMessage: json['mainMessage'],
      viewed: json['viewed'],
      good: json['good'],
      type: json['type'],
      commentCount: json['count'],
      postTime: json['postTime'],
    );
  }

  ///My投稿のAPIからUserDataなし場合使用する
  factory PostModel.noUserDataPostAddUserData({required PostModel noUserDatPost, required ProfileData userData}) {
    PostModel addedUserDataPost = noUserDatPost;
    addedUserDataPost.postUserInfo = userData;
    return addedUserDataPost;
  }

  // static String dateFormatted(String time) {
  //   DateTime dateUtc = DateTime.parse(time).toUtc();

  //   Duration duration = DateTime.now().toUtc().difference(dateUtc);
  //   String durationTime = "";
  //   if (duration.inMinutes < 60) {
  //     durationTime = "${duration.inMinutes} 分";
  //   } else if (duration.inMinutes >= 60 && duration.inMinutes < 1440) {
  //     durationTime = "${duration.inHours} 時";
  //   } else if (duration.inMinutes >= 1440) {
  //     durationTime = "${duration.inDays} 天";
  //   }
  //   String formattedTime = durationTime;
  //   return formattedTime;
  // }

  PostModel copyWith({PostModel? data}) {
    return PostModel(
      id: data?.id ?? id,
      createdBy: data?.createdBy ?? createdBy,
      title: data?.title ?? title,
      mainMessage: data?.mainMessage ?? mainMessage,
      postTime: data?.postTime ?? postTime,
      viewed: data?.viewed ?? viewed,
      good: data?.good ?? good,
      type: data?.type ?? type,
      commentCount: data?.commentCount ?? commentCount,
      postUserInfo: data?.postUserInfo ?? postUserInfo,
    );
  }
}

class CreatePostModel {
  String createdByUId;
  String title;
  String mainMessage;
  int type;
  CreatePostModel({required this.createdByUId, required this.title, required this.mainMessage, required this.type});

  String createPost() {
    return jsonEncode({
      "createdBy": createdByUId,
      "title": title,
      "mainMessage": mainMessage,
      "type": type,
    });
  }
}

class PostCommentTextEditorModel {
  int uid;
  int postId;
  String userUid;
  String message;
  String postTime;
  ProfileData commentUserInfo;
  bool isEditor;
  TextEditingController textEditingController;

  PostCommentTextEditorModel({
    required this.uid,
    required this.postId,
    required this.userUid,
    required this.message,
    required this.postTime,
    required this.commentUserInfo,
    required this.isEditor,
    required this.textEditingController,
  });

  factory PostCommentTextEditorModel.toMap(dynamic json) {
    TextEditingController controller = TextEditingController();
    controller.text = json['message'];

    return PostCommentTextEditorModel(
      uid: json['id'],
      postId: json['postId'],
      userUid: json['userUid'],
      message: json['message'],
      postTime: json['postTime'] ?? "",
      commentUserInfo: ProfileData.toModel(json['user']),
      isEditor: false,
      textEditingController: controller,
    );
  }
}
