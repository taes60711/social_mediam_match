import 'package:social_mediam_match/models/user_model.dart';

class ChatRoomModel {
  int pageCount;
  List<String> members;
  List<ChatRoomMsg> chatRoomMsg;

  ChatRoomModel({
    this.pageCount = -1,
    this.members = const [],
    required this.chatRoomMsg,
  });
  factory ChatRoomModel.toModel(dynamic json) {
    return ChatRoomModel(
      pageCount: json['PageCount'],
      members: (json["Members"] as List<dynamic>).map((e) => "\"$e\"").toList(),
      chatRoomMsg: (json["Message"] as List<dynamic>).map((e) => ChatRoomMsg.toModel(e)).toList(),
    );
  }

  ChatRoomModel copyWith({
    int? pageCount,
    List<String>? members,
    List<ChatRoomMsg>? chatRoomMsg,
  }) {
    return ChatRoomModel(
      pageCount: pageCount ?? this.pageCount,
      members: members ?? this.members,
      chatRoomMsg: chatRoomMsg ?? this.chatRoomMsg,
    );
  }
}

class ChatRoomMsg {
  String userId;
  String message;
  String sentAt;
  bool needAppearImg;

  ChatRoomMsg({
    required this.userId,
    required this.message,
    required this.sentAt,
    required this.needAppearImg,
  });
  factory ChatRoomMsg.toModel(dynamic json) {
    return ChatRoomMsg(
      userId: json['userId'],
      message: json['message'],
      sentAt: json['sentAt'],
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
  int unreadCount;
  int roomType;
  ProfileData userData;

  FriendListModel({
    required this.roomId,
    required this.createdBy,
    required this.memberId,
    this.lastMessage,
    required this.sentAt,
    required this.unreadCount,
    required this.roomType,
    required this.userData,
  });

  factory FriendListModel.toModel(dynamic json, {ProfileData? userData}) {
    return FriendListModel(
      roomId: json['roomId'],
      memberId: json['memberId'],
      createdBy: json['createdBy'],
      lastMessage: json['lastMessage'],
      unreadCount: json["unreadCount"],
      sentAt: json['sentAt'],
      roomType: json['roomType'],
      userData: userData ?? ProfileData.toModel(json['user']),
    );
  }

  FriendListModel copyWith() {
    return FriendListModel(
      roomId: roomId,
      createdBy: createdBy,
      memberId: memberId,
      lastMessage: lastMessage,
      sentAt: sentAt,
      unreadCount: unreadCount,
      roomType: roomType,
      userData: userData,
    );
  }
}
