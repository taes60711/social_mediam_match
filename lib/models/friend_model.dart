import 'package:intl/intl.dart';

class ChatRoomMessageModel {
  String userId;
  String message;
  String sentAt;
  ChatRoomMessageModel({required this.userId, required this.message, required this.sentAt});
  factory ChatRoomMessageModel.fromJson(dynamic json) {
    DateTime dateUtc = DateTime.parse(json['sentAt']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

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
  FriendListModel({
    required this.roomId,
    required this.roomName,
    required this.memberId,
    this.lastMessage,
    required this.roomType,
  });

  factory FriendListModel.fromJson(dynamic json) {
    return FriendListModel(
      roomId: json['roomId'],
      memberId: json['memberId'],
      roomName: json['roomName'],
      lastMessage: json['lastMessage'],
      roomType: json['roomType'],
    );
  }
}
