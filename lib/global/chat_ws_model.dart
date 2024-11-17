import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';

import '../components/home/firendsPage/firends_page.dart';
import '../global.dart';
import '../models/friend_model.dart';
import '../services/friend_service.dart';

class ChatWSModel {
  static ChatWSModel? _instance;

  ChatWSModel._();

  factory ChatWSModel() {
    return _instance ??= ChatWSModel._();
  }

  late WidgetRef ref;
  late Function render;

  late IOWebSocketChannel _friendListChannel;
  Stream<dynamic>? _broadcastStream;

  Future<void> init(WidgetRef ref, Function render, {required String userId}) async {
    this.ref = ref;
    this.render = render;
    _friendListChannel = IOWebSocketChannel.connect(channelListUrl);
    print("friendList connect");
    await _friendListChannel.ready;

    Map<String, dynamic> map = {
      "method": "connect",
      "ip": "$ip:$port",
      "userid": userId,
    };

    _friendListChannel.sink.add(jsonEncode(map));
    stream();
  }

  Stream<dynamic>? stream() {
    if (_broadcastStream != null) {
      return null;
    }

    _friendListChannel.stream.listen((event) async {
      print(event);
      String searchUrl = jsonDecode((event))['apiUrl'];
      List<FriendListModel> tempfriendList = await FriendService().getFriendList(searchUrl);
      String initDate = "1997-01-01T00:00:00.000+00:00";

      tempfriendList.sort((a, b) => DateTime.parse(a.sentAt ?? initDate).compareTo(DateTime.parse(b.sentAt ?? initDate)));
      tempfriendList = tempfriendList.map((e) {
        return friendListFormatDate(e);
      }).toList();

      ref.read(frinedListProvider.notifier).update((state) => tempfriendList);
      render();
    });

    return _broadcastStream = _friendListChannel.stream.asBroadcastStream();
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    //index 0 : 使用者自己, index 1 : 對方
    for (var element in usersList) {
      usersListTemp = [...usersListTemp, element];
    }

    Map<String, dynamic> map = {
      "method": "addFriend",
      "ip": "$ip:$port",
      "members": usersListTemp,
    };

    _friendListChannel.sink.add(jsonEncode(map));
  }
}
