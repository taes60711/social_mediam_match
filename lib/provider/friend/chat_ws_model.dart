import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:web_socket_channel/io.dart';

import '../../components/home/firendsPage/firends_page.dart';
import '../../global.dart';
import '../../models/friend_model.dart';
import '../../services/friend_service.dart';

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

  final String _channelListUrl = APIHttpController.wsPreFixUrl;

  String? filteredText;

  Future<void> init(WidgetRef ref, Function render, {required String userId}) async {
    this.ref = ref;
    this.render = render;

    if (_broadcastStream != null) {
      closeStream();
    }

    _friendListChannel = IOWebSocketChannel.connect(_channelListUrl);
    print("friendList connect $_channelListUrl");
    await _friendListChannel.ready;

    Map<String, dynamic> map = {
      "method": "connect",
      "ip": APIHttpController.domainUrl,
      "userid": userId,
    };

    _friendListChannel.sink.add(jsonEncode(map));
    stream();
  }

  void closeStream() {
    print("friendList close");
    _broadcastStream = null;
    _friendListChannel.sink.close();
  }

  Stream<dynamic>? stream() {
    if (_broadcastStream != null) {
      return null;
    }

    _friendListChannel.stream.listen((event) async {
      print("_friendListChannel $event");

      String searchUrl = jsonDecode((event))['apiUrl'];

      ///監聽會有added 為被加的使用者資訊
      String? realApiUrl = searchUrl.contains(ref.watch(loginUserData).uid) ? searchUrl : null;
      if (realApiUrl != null) {
        List<FriendListModel> tempfriendList = await FriendService().getFriendList(searchUrl);

        String initDate = "1997-01-01T00:00:00.000+00:00";

        tempfriendList.sort((a, b) => DateTime.parse(b.sentAt ?? initDate).compareTo(DateTime.parse(a.sentAt ?? initDate)));

        ref.read(frinedListProvider.notifier).update((state) => tempfriendList);

        getFilterList(inputedName: filteredText);
        // render();
      }
    });

    return _broadcastStream = _friendListChannel.stream.asBroadcastStream();
  }

  void sendMsg(List<String> usersList, int roomId) {
    Map<String, dynamic> map = {
      "method": "sendMessage",
      "ip": APIHttpController.domainUrl,
      "members": usersList,
      "roomid": roomId,
    };

    String memberUID = usersList.firstWhere((e) => e != ref.watch(loginUserData).uid);

    FriendService().updateUnreadCount(roomId, memberUID, 1);

    _friendListChannel.sink.add(jsonEncode(map));
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    //index 0 : 使用者自己, index 1 : 對方
    for (var element in usersList) {
      usersListTemp = [...usersListTemp, element];
    }

    Map<String, dynamic> map = {
      "method": "addFriend",
      "ip": APIHttpController.domainUrl,
      "members": usersListTemp,
    };

    _friendListChannel.sink.add(jsonEncode(map));
  }

  void getFilterList({String? inputedName}) {
    List<FriendListModel> filteredList = [];

    if (inputedName != null) {
      filteredList = List.from(
        ref.read(frinedListProvider.notifier).state.where(
              (element) => element.userData.name!.contains(inputedName),
            ),
      );
    } else {
      filteredList = List.from(ref.read(frinedListProvider.notifier).state);
    }

    ref.read(filterFriendListProvider.notifier).update((state) => filteredList);

    render();
  }
}
