import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class PostModel {
  int id;
  String createdBy;
  String mainMessage;
  String postTime;
  int commentCount;
  LoginUser postUserInfo;
  PostModel({
    required this.id,
    required this.createdBy,
    required this.mainMessage,
    required this.commentCount,
    required this.postTime,
    required this.postUserInfo,
  });

  factory PostModel.toMap(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['postTime']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    return PostModel(
      id: json['id'],
      createdBy: json['createdBy'],
      mainMessage: json['mainMessage'],
      commentCount: json['count'],
      postTime: formattedTime,
      postUserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}

class PostCommentModel {
  int postId;
  String userUid;
  String message;
  String postTime;
  LoginUser commentUserInfo;

  PostCommentModel({
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
      postId: json['postId'],
      userUid: json['userUid'],
      message: json['message'],
      postTime: formattedTime,
      commentUserInfo: LoginUser.jsonToModel(json['user']),
    );
  }
}
