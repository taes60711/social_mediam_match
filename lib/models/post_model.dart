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
  String mainMessage;
  List<String> fileMessage;
  String postTime;
  int viewed;
  int good;
  int type;
  int commentCount;
  bool loginUserIsGood;
  ProfileData postUserInfo;
  PostModel({
    this.id = -1,
    this.createdBy = "",
    this.mainMessage = "",
    this.fileMessage = const [],
    this.postTime = "",
    this.viewed = 0,
    this.good = 0,
    this.type = 0,
    this.commentCount = 0,
    this.loginUserIsGood = false,
    ProfileData? postUserInfo,
  }) : postUserInfo = postUserInfo ?? ProfileData();

  factory PostModel.toMap(dynamic json) {
    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
      mainMessage: json['mainMessage'],
      fileMessage: json['fileMessage'] == null ? [] : (json['fileMessage'] as List<dynamic>).map((e) => e as String).toList(),
      viewed: json['viewed'],
      good: json['good'],
      type: json['type'],
      commentCount: json['count'],
      loginUserIsGood: json['userIsGood'],
      postTime: json['postTime'],
      postUserInfo: json['user'] == null ? ProfileData() : ProfileData.toModel(json['user']),
    );
  }

  factory PostModel.myPostToMap(dynamic json) {
    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
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
      mainMessage: data?.mainMessage ?? mainMessage,
      fileMessage: data?.fileMessage ?? fileMessage,
      loginUserIsGood: data?.loginUserIsGood ?? loginUserIsGood,
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
      'mainMessage': mainMessage,
      'userIsGood': loginUserIsGood,
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

  PostCommentTextEditorModel copyWith() {
    return PostCommentTextEditorModel(
      uid: uid,
      postId: postId,
      userUid: userUid,
      message: message,
      postTime: postTime,
      commentUserInfo: commentUserInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'postId': postId,
      'userUid': userUid,
      'message': message,
      'postTime': postTime,
      'user': commentUserInfo,
    };
  }
}
