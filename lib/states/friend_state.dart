import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../global.dart';

class FriendState extends ChangeNotifier {
  String channelListUrl;
  late IOWebSocketChannel friendListChannel;
  late IOWebSocketChannel chatRoomChannel;
  Stream? friendListStream;
  String friendListMessage = "";
  String chatRoomMesaage = "";
  List<String> members = [];
  final GlobalKey<ScaffoldState> key = GlobalKey();
  int roomId = -1;

  bool isSendMessage = false;

  FriendState({required this.channelListUrl});

  void friendListConnect(String uid) async {
    Future<void> initialConnect() async {
      friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    }

    await initialConnect();
    await friendListChannel.ready;
    friendListChannel.sink.add('{"method" : "connect" , "userid" : "$uid"}');
    friendListChannel.stream.listen((event) {
      friendListMessage = event;
      notifyListeners();
    });
  }

  Future<void> openRoom(int roomId) async {
    Future<void> initialConnect() async {
      chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await chatRoomChannel.ready;
      chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : $roomId}');
      this.roomId = roomId;
      notifyListeners();
    }

    await initialConnect();

    chatRoomChannel.stream.listen((event) {
      (jsonDecode(event)["Members"] as List<dynamic>).forEach((element) {
        members = [...members, "\"$element\""];
      });
      chatRoomMesaage = event;
      notifyListeners();

      if (isSendMessage) {
        friendListChannel.sink.add('{"method" : "sendMessage" , "members" : $members}');
        isSendMessage = false;
      }
    });
  }

  void closeRoom() {
    chatRoomChannel.sink.close();
  }

  void sendMessage(int roomId, String userId, String message) {
    chatRoomChannel.sink.add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
    isSendMessage = true;
  }
}
