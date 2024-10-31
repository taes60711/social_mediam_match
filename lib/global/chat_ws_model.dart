import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';

import '../global.dart';

class ChatWSModel {
  static ChatWSModel? _instance;

  ChatWSModel._();

  factory ChatWSModel() {
    return _instance ??= ChatWSModel._();
  }

  late IOWebSocketChannel _friendListChannel;
  Stream<dynamic>? _broadcastStream;

  Future<void> init(String userId) async {
    _friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    print("friendList connect");
    await _friendListChannel.ready;

    Map<String, dynamic> map = {
      "method": "connect",
      "ip": "$ip:$port",
      "userid": userId,
    };

    _friendListChannel.sink.add(jsonEncode(map));
  }

  Stream<dynamic>? listen() {
    if (_broadcastStream != null) {
      return null;
    }
    return _broadcastStream = _friendListChannel.stream.asBroadcastStream();
  }

  void test() {
    Map<String, dynamic> map = {
      "method": "connect",
      "ip": "$ip:$port",
      "userid": "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2",
    };
    _friendListChannel.sink.add(jsonEncode(map));
  }
}
