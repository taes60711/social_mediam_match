import 'dart:convert';

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
  int? roomId;
  DateTime postTime;
  ProfileData sendNotificationuserInfo;

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
    this.roomId,
    required this.postTime,
    required this.sendNotificationuserInfo,
  });

  factory NotificationModel.empty() {
    return NotificationModel(
      id: 0,
      userUid: '',
      otherUserUid: '',
      type: 0,
      title: '',
      isRead: false,
      message: '',
      postId: null,
      courseId: null,
      roomId: null,
      postTime: DateTime.now(),
      sendNotificationuserInfo: ProfileData(),
    );
  }

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
      sendNotificationuserInfo: ProfileData.toModel(json['user']),
    );
  }

  static String receviceDataToJson(NotificationModel data) {
    Map<String, dynamic> returnData = {
      "type": data.type,
      "postId": data.postId,
      "courseId": data.courseId,
      "roomId": data.roomId,
      "otherUser": data.otherUserUid,
    };
    return jsonEncode(returnData);
  }

  static NotificationModel receviceDatatoModel(String data) {
    Map<String, dynamic> mapData = jsonDecode(data);
    return NotificationModel(
      id: -1,
      userUid: "",
      otherUserUid: mapData['otherUser'],
      type: mapData["type"],
      postId: mapData['postId'],
      courseId: mapData['courseId'],
      roomId: mapData['roomId'],
      title: "",
      isRead: false,
      message: "",
      postTime: DateTime.now(),
      sendNotificationuserInfo: ProfileData(),
    );
  }
}
