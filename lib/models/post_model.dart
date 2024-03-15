import 'package:intl/intl.dart';

class PostModel {
  int id;
  String createdBy;
  String mainMessage;
  String postTime;
  int commentCount;
  PostModel({
    required this.id,
    required this.createdBy,
    required this.mainMessage,
    required this.commentCount,
    required this.postTime,
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
    );
  }
}

class PostCommentModel {
  int postId;
  String userUid;
  String message;
  String postTime;

  PostCommentModel({
    required this.postId,
    required this.userUid,
    required this.message,
    required this.postTime,
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
    );
  }
}
