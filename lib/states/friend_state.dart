import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../global.dart';

class FriendState extends ChangeNotifier {
  late IOWebSocketChannel _friendListChannel, _chatRoomChannel;
  bool _isSendMessage = false;
  String friendListMessage = "", chatRoomMesaage = "";
  List<String> members = [];
  final GlobalKey<ScaffoldState> key = GlobalKey();
  int roomId = -1;

  String channelListUrl;
  FriendState({required this.channelListUrl});

  void friendListConnect(String uid) async {
    Future<void> initialConnect() async {
      _friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    }

    await initialConnect();
    await _friendListChannel.ready;
    _friendListChannel.sink.add('{"method" : "connect" , "userid" : "$uid"}');
    _friendListChannel.stream.listen((event) {
      friendListMessage = event;
      notifyListeners();
    });
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "addFriend","members" : $usersListTemp}');
  }

  Future<void> openRoom(int roomId) async {
    Future<void> initialConnect() async {
      _chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await _chatRoomChannel.ready;
      _chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : $roomId}');
      this.roomId = roomId;
      notifyListeners();
    }

    await initialConnect();

    _chatRoomChannel.stream.listen((event) {
      (jsonDecode(event)["Members"] as List<dynamic>).forEach((element) {
        members = [...members, "\"$element\""];
      });
      chatRoomMesaage = event;
      notifyListeners();

      if (_isSendMessage) {
        _friendListChannel.sink.add('{"method" : "sendMessage" , "members" : $members}');
        _isSendMessage = false;
      }
    });
  }

  void closeRoom() {
    _chatRoomChannel.sink.close();
  }

  void sendMessage(int roomId, String userId, String message) {
    _chatRoomChannel.sink.add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
    _isSendMessage = true;
  }
}
