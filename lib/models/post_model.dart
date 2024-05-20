import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

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
    required this.id,
    required this.createdBy,
    required this.title,
    required this.mainMessage,
    required this.viewed,
    required this.good,
    required this.type,
    required this.commentCount,
    required this.postTime,
    required this.postUserInfo,
  });

  factory PostModel.toMap(dynamic json, {LoginUser? userData}) {
    // DateTime dateUtc = DateTime.parse(json['postTime']).toUtc();
    // DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    // String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());
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
    String formattedTime = durationTime;
    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
      title: json['title'],
      mainMessage: json['mainMessage'],
      viewed: json['viewed'],
      good: json['good'],
      type: json['type'],
      commentCount: json['count'],
      postTime: formattedTime,
      postUserInfo: userData ?? LoginUser.jsonToModel(json['user']),
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

class UpdatePostModel {
  int id;
  String mainMessage;
  UpdatePostModel({required this.id, required this.mainMessage});

  String updatePost() {
    return jsonEncode({
      "id": id,
      "mainMessage": mainMessage,
    });
  }
}

class PostCommentModel {
  int uid;
  int postId;
  String userUid;
  String message;
  String postTime;
  LoginUser commentUserInfo;

  PostCommentModel({
    required this.uid,
    required this.postId,
    required this.userUid,
    required this.message,
    required this.postTime,
    required this.commentUserInfo,
  });

  factory PostCommentModel.toMap(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['postTime']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    return PostCommentModel(
      uid: json['id'],
      postId: json['postId'],
      userUid: json['userUid'],
      message: json['message'],
      postTime: formattedTime,
      commentUserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}

class getPostCommentModel {
  int uid;
  int postId;
  String userUid;
  String message;
  bool isEditor;
  String postTime;

  LoginUser commentUserInfo;

  getPostCommentModel({
    required this.uid,
    required this.postId,
    required this.userUid,
    required this.message,
    required this.isEditor,
    required this.postTime,
    required this.commentUserInfo,
  });
}

class UpdateCommentPostModel {
  int id;
  String message;
  UpdateCommentPostModel({required this.id, required this.message});

  String updatePost() {
    return jsonEncode({
      "id": id,
      "message": message,
    });
  }
}
