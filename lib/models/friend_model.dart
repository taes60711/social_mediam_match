import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class ChatRoomMessageModel {
  String userId;
  String message;
  String sentAt;
  bool needAppearImg;
  ChatRoomMessageModel({
    required this.userId,
    required this.message,
    required this.sentAt,
    required this.needAppearImg,
  });
  factory ChatRoomMessageModel.fromJson(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['sentAt']).toUtc();

    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd a hh:mm").format(dateTime.toLocal());

    return ChatRoomMessageModel(
      userId: json['userId'],
      message: json['message'],
      sentAt: formattedTime,
      needAppearImg: false,
    );
  }
}

class FriendListModel {
  int roomId;
  String createdBy;
  String memberId;
  String? lastMessage;
  String? sentAt;
  int roomType;
  LoginUser userData;

  FriendListModel({
    required this.roomId,
    required this.createdBy,
    required this.memberId,
    this.lastMessage,
    required this.sentAt,
    required this.roomType,
    required this.userData,
  });

  factory FriendListModel.fromJson(dynamic json, LoginUser? userData) {
    String? formattedTime;
    if (json['sentAt'] != null) {
      DateTime sentAtTime =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.parse(json['sentAt']).toUtc().toString(), true).toLocal();
      DateTime dateTimeNow = DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toUtc().toString(), true).toLocal();
      String sentTimeString = sentAtTime.toIso8601String().substring(0, "yyyy-MM-dd".length);
      String timseNowString = dateTimeNow.toIso8601String().substring(0, "yyyy-MM-dd".length);

      print("dateTimeNow :$timseNowString dateTime :$sentTimeString");

      if (timseNowString != sentTimeString) {
        formattedTime = sentTimeString;
      } else {
        formattedTime = DateFormat("a hh:mm").format(sentAtTime);
      }
    }

    return FriendListModel(
      roomId: json['roomId'],
      memberId: json['memberId'],
      createdBy: json['createdBy'],
      lastMessage: json['lastMessage'],
      sentAt: formattedTime,
      roomType: json['roomType'],
      userData: userData ?? LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0),
    );
  }
}
