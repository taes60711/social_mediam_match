import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class FriendState extends ChangeNotifier {
  String channelListUrl;
  late IOWebSocketChannel friendListChannel;

  Stream? friendListStream;
  Stream? chatRoomStream;
  int roomId = -1;

  FriendState({required this.channelListUrl});

  void friendListConnect(String uid) async {
    Future<void> initialConnect() async {
      friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    }

    await initialConnect();
    await friendListChannel.ready;
    friendListChannel.sink.add('{"method" : "connect" , "userid" : "$uid"}');
    friendListStream = friendListChannel.stream;
    notifyListeners();
  }

  void openRoom(int roomId) {
    this.roomId = roomId;
    notifyListeners();
  }
}
