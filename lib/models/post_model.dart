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
  LoginUser postUserInfo;
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
    LoginUser? postUserInfo,
  }) : postUserInfo = postUserInfo ?? LoginUser();

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
      postTime: dateFormatted(json['postTime']),
      postUserInfo: LoginUser.toModel(json['user']),
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
      postTime: dateFormatted(json['postTime']),
    );
  }

  ///My投稿のAPIからUserDataなし場合使用する
  factory PostModel.noUserDataPostAddUserData({required PostModel noUserDatPost, required LoginUser userData}) {
    PostModel addedUserDataPost = noUserDatPost;
    addedUserDataPost.postUserInfo = userData;
    return addedUserDataPost;
  }

  static String dateFormatted(String time) {
    DateTime dateUtc = DateTime.parse(time).toUtc();

    Duration duration = DateTime.now().toUtc().difference(dateUtc);
    String durationTime = "";
    if (duration.inMinutes < 60) {
      durationTime = "${duration.inMinutes} 分";
    } else if (duration.inMinutes >= 60 && duration.inMinutes < 1440) {
      durationTime = "${duration.inHours} 時";
    } else if (duration.inMinutes >= 1440) {
      durationTime = "${duration.inDays} 天";
    }
    String formattedTime = durationTime;
    return formattedTime;
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
  LoginUser commentUserInfo;
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
    // DateTime dateUtc = DateTime.parse(json['postTime']).toUtc();
    // DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    // String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    String formattedTime = "";
    if (json['postTime'] != null) {
      DateTime dateUtc = DateTime.parse(json['postTime']).toUtc();
      Duration duration = DateTime.now().toUtc().difference(dateUtc);
      String durationTime = "";
      if (duration.inMinutes < 60) {
        durationTime = "${duration.inMinutes} 分";
      } else if (duration.inMinutes >= 60 && duration.inMinutes < 1440) {
        durationTime = "${duration.inHours} 時";
      } else if (duration.inMinutes >= 1440) {
        durationTime = "${duration.inDays} 天";
      }
      formattedTime = durationTime;
    }

    TextEditingController controller = TextEditingController();
    controller.text = json['message'];

    return PostCommentTextEditorModel(
      uid: json['id'],
      postId: json['postId'],
      userUid: json['userUid'],
      message: json['message'],
      postTime: formattedTime,
      commentUserInfo: LoginUser.toModel(json['user']),
      isEditor: false,
      textEditingController: controller,
    );
  }
}
