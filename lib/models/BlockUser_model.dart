import 'user_model.dart';

class BlockUser {
  String uid;
  String blockUID;
  String createdTime;
  ProfileData userInfo;

  BlockUser({required this.uid, required this.blockUID, required this.createdTime, required this.userInfo});

  factory BlockUser.toMap(dynamic json) {
    return BlockUser(
      uid: json['uid'],
      blockUID: json['block_uid'],
      createdTime: json['createdTime'],
      userInfo: json['user'] == null ? ProfileData() : ProfileData.toModel(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'block_uid': blockUID,
      'createdTime': createdTime,
      'user': userInfo,
    };
  }
}
