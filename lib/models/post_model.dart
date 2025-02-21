import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:social_mediam_match/models/user_model.dart';

class PostBoard {
  int id;
  int type;
  String name;
  String chineseName;

  /// サーバーからデータではない
  IconData? iconData;

  PostBoard({
    this.id = 0,
    this.type = 0,
    this.name = "chat",
    this.chineseName = "聊天",
    this.iconData,
  });

  factory PostBoard.toMap(dynamic json) {
    return PostBoard(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      chineseName: json["chineseName"],
    );
  }
}

class PostModel {
  int id;
  String createdBy;
  String title;
  String mainMessage;
  List<String> fileMessage;
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
    this.fileMessage = const [],
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
      fileMessage: json['fileMessage'] == null ? [] : (json['fileMessage'] as List<dynamic>).map((e) => e as String).toList(),
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
      fileMessage: json['fileMessage'] == null ? [] : (json['fileMessage'] as List<dynamic>).map((e) => e as String).toList(),
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

  PostModel copyWith({PostModel? data}) {
    return PostModel(
      id: data?.id ?? id,
      createdBy: data?.createdBy ?? createdBy,
      title: data?.title ?? title,
      mainMessage: data?.mainMessage ?? mainMessage,
      fileMessage: data?.fileMessage ?? fileMessage,
      postTime: data?.postTime ?? postTime,
      viewed: data?.viewed ?? viewed,
      good: data?.good ?? good,
      type: data?.type ?? type,
      commentCount: data?.commentCount ?? commentCount,
      postUserInfo: data?.postUserInfo ?? postUserInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'title': title,
      'mainMessage': mainMessage,
      'fileMessage': fileMessage,
      'postTime': postTime,
      'viewed': viewed,
      'good': good,
      'type': type,
      'commentCount': commentCount,
      'postUserInfo': postUserInfo.toJson(),
    };
  }
}

class CreatePostModel {
  String createdByUId;
  String title;
  String mainMessage;
  List<String> fileMessage;
  int type;
  CreatePostModel(
      {required this.createdByUId,
      required this.title,
      required this.mainMessage,
      required this.fileMessage,
      required this.type});

  String createPost() {
    return jsonEncode({
      "createdBy": createdByUId,
      "title": title,
      "mainMessage": mainMessage,
      "fileMessage": fileMessage,
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

  PostCommentTextEditorModel({
    this.uid = 0,
    this.postId = 0,
    this.userUid = "",
    this.message = "",
    this.postTime = "",
    ProfileData? commentUserInfo,
  }) : commentUserInfo = commentUserInfo ?? ProfileData();

  factory PostCommentTextEditorModel.toMap(dynamic json) {
    return PostCommentTextEditorModel(
      uid: json['id'],
      postId: json['postId'],
      userUid: json['userUid'],
      message: json['message'],
      postTime: json['postTime'] ?? "",
      commentUserInfo: ProfileData.toModel(json['user']),
    );
  }

  // 添加copyWith方法
  PostCommentTextEditorModel copyWith() {
    return PostCommentTextEditorModel(
      uid: this.uid,
      postId: this.postId,
      userUid: this.userUid,
      message: this.message,
      postTime: this.postTime,
      commentUserInfo: this.commentUserInfo,
    );
  }
}
