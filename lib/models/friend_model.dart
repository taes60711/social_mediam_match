import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/user_model.dart';

class ChatRoomMessageModel {
  String userId;
  String message;
  String sentAt;
  ChatRoomMessageModel({required this.userId, required this.message, required this.sentAt});
  factory ChatRoomMessageModel.fromJson(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['sentAt']).toUtc();

    DateTime now = DateTime.now().toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd a hh:mm").format(dateTime.toLocal());

    return ChatRoomMessageModel(
      userId: json['userId'],
      message: json['message'],
      sentAt: formattedTime,
    );
  }
}

class FriendListModel {
  int roomId;
  String roomName;
  String memberId;
  String? lastMessage;
  int roomType;
  LoginUser userData;
  FriendListModel({
    required this.roomId,
    required this.roomName,
    required this.memberId,
    this.lastMessage,
    required this.roomType,
    required this.userData,
  });

  factory FriendListModel.fromJson(dynamic json, LoginUser? userData) {
    return FriendListModel(
      roomId: json['roomId'],
      memberId: json['memberId'],
      roomName: json['roomName'],
      lastMessage: json['lastMessage'],
      roomType: json['roomType'],
      userData: userData ?? LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0),
    );
  }
}
