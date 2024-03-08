import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class FriendState extends ChangeNotifier {
  String channelListUrl;
  late IOWebSocketChannel friendListChannel;

  Stream? friendListStream;
  String friendListMessage = "";
  int roomId = -1;

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

  void openRoom(int roomId) {
    this.roomId = roomId;
    notifyListeners();
  }
}
