import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class FriendState extends ChangeNotifier {
  String channelListUrl;
  late IOWebSocketChannel friendListChannel;
  Stream? chatRoomListStream;

  FriendState({required this.channelListUrl});

  void webSocketConnect(String uid) async {
    Future<void> initialConnect() async {
      friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    }

    await initialConnect();
    await friendListChannel.ready;
    friendListChannel.sink.add('{"method" : "connect" , "userid" : "$uid"}');
    chatRoomListStream = friendListChannel.stream;
    notifyListeners();
  }
}
