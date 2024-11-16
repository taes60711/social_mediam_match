import 'package:intl/intl.dart';
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
    DateTime dateUtc = DateTime.parse(json['sentAt']).toUtc();

    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd a hh:mm").format(dateTime.toLocal());

    return ChatRoomMsg(
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
  ProfileData userData;

  FriendListModel({
    required this.roomId,
    required this.createdBy,
    required this.memberId,
    this.lastMessage,
    required this.sentAt,
    required this.roomType,
    required this.userData,
  });

  factory FriendListModel.toModel(dynamic json, {ProfileData? userData}) {
    return FriendListModel(
      roomId: json['roomId'],
      memberId: json['memberId'],
      createdBy: json['createdBy'],
      lastMessage: json['lastMessage'],
      sentAt: json['sentAt'],
      roomType: json['roomType'],
      userData: userData ?? ProfileData.toModel(json['user']),
    );
  }
}

FriendListModel friendListFormatDate(FriendListModel friendListInfo) {
  String? formattedTime;
  if (friendListInfo.sentAt != null) {
    DateTime sentAtTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.parse(friendListInfo.sentAt ?? "").toUtc().toString(), true).toLocal();
    DateTime dateTimeNow = DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toUtc().toString(), true).toLocal();
    String sentTimeString = sentAtTime.toIso8601String().substring(0, "yyyy-MM-dd".length);
    String timseNowString = dateTimeNow.toIso8601String().substring(0, "yyyy-MM-dd".length);

    if (timseNowString != sentTimeString) {
      formattedTime = sentTimeString;
    } else {
      formattedTime = DateFormat("a hh:mm").format(sentAtTime);
    }
  }
  return FriendListModel(
    roomId: friendListInfo.roomId,
    memberId: friendListInfo.memberId,
    createdBy: friendListInfo.createdBy,
    lastMessage: friendListInfo.lastMessage,
    sentAt: formattedTime,
    roomType: friendListInfo.roomType,
    userData: friendListInfo.userData,
  );
}
