import 'user_model.dart';

class NotificationModel {
  int id;
  String userUid;
  String otherUserUid;
  int type;
  String title;
  bool isRead;
  String message;
  int? postId;
  int? courseId;
  DateTime postTime;
  LoginUser sendNotificationuserInfo;

  NotificationModel({
    required this.id,
    required this.userUid,
    required this.otherUserUid,
    required this.type,
    required this.title,
    required this.isRead,
    required this.message,
    this.postId,
    this.courseId,
    required this.postTime,
    required this.sendNotificationuserInfo,
  });

  factory NotificationModel.toMap(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userUid: json['userUid'],
      otherUserUid: json['otherUserUid'],
      type: json['type'],
      title: json['title'],
      isRead: json['isRead'],
      message: json['message'],
      postId: json['postId'],
      courseId: json['courseId'],
      postTime: DateTime.parse(json['postTime']),
      sendNotificationuserInfo: LoginUser.toModel(json['user']),
    );
  }
}
