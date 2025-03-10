import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/provider/friend/chat_ws_model.dart';
import 'package:web_socket_channel/io.dart';

import '../../components/home/firendsPage/chatRoomPage/chat_room.dart';
import '../../enum/user_block_status_type.dart';
import '../../models/friend_model.dart';
import '../../services/friend_service.dart';
import '../../services/user_service.dart';

class ChatRoomWSModel {
  static ChatRoomWSModel? _instance;

  ChatRoomWSModel._();

  factory ChatRoomWSModel() {
    return _instance ??= ChatRoomWSModel._();
  }

  final String _channelRoomUrl = "${APIHttpController.wsPreFixUrl}/chatroom";

  late WidgetRef ref;
  late Function render;
  late Function closePage;
  int enterRoomID = -1;
  int roomAllPage = -1;
  int pageNum = 0;
  int insendMsgCount = 0;

  String notificationToken = "";

  bool inBackground = false;
  bool isOffScreen = false;

  bool isBlocked = false;

  late IOWebSocketChannel _chatroomListChannel;
  Stream<dynamic>? _broadcastStream;

  Future<void> init(WidgetRef ref, Function render, Function closePage,
      {required String userId, required FriendListModel roomData}) async {
    this.ref = ref;
    this.render = render;
    this.closePage = closePage;
    if (enterRoomID != -1) {
      closeRoom();
    }

    enterRoomID = roomData.roomId;
    ref.read(loginUserInChatRoomId.notifier).update((state) => enterRoomID);
    _chatroomListChannel = IOWebSocketChannel.connect(_channelRoomUrl);

    UserBlockStatusType userBlockStatusType = await HomeGlobalViewModel().getUserBlockStatus(userData: roomData.userData);
    isBlocked = userBlockStatusType == UserBlockStatusType.blocked;

    print("chatRoom connect $_channelRoomUrl");
    await _chatroomListChannel.ready;

    Map<String, dynamic> map = {
      "method": "connect",
      "ip": APIHttpController.domainUrl,
      "userid": userId,
      "roomid": roomData.roomId,
      "pageNumber": pageNum,
    };

    _chatroomListChannel.sink.add(jsonEncode(map));
    stream();

    // FlutterAppBadger.isAppBadgeSupported().then((isSupport) {
    //   if (isSupport) {
    //     FlutterAppBadger.removeBadge();
    //   }
    // });

    notificationToken = await UserService().requestUserNotificationTokenByUID(roomData.userData.uid);
  }

  Stream<dynamic>? stream() {
    if (_broadcastStream != null) {
      return null;
    }

    _chatroomListChannel.stream.listen((event) async {
      print("_chatroomListChannel $event");

      Map<String, dynamic> requestMapData = jsonDecode((event as String));

      String listendMethod = requestMapData['method'];

      switch (listendMethod) {
        case "connect":
          String searchUrl = requestMapData['apiUrl'];

          ChatRoomModel chatRoomModel = await FriendService().getChatRoomMsg(searchUrl);
          ref.read(roomMessageProvider.notifier).update((state) => chatRoomModel);
          roomAllPage = chatRoomModel.pageCount;
          render();
        case "load":
          String searchUrl = requestMapData['apiUrl'];

          ChatRoomModel chatRoomModel = await FriendService().getChatRoomMsg(searchUrl);

          ref.read(roomMessageProvider.notifier).update((state) {
            final updatedMessages = [...state.chatRoomMsg, ...chatRoomModel.chatRoomMsg];
            return state.copyWith(chatRoomMsg: updatedMessages);
          });

          render();
        case "sendMessage":
          var loadedData = event;
          ChatRoomMsg tempchatRoomMessage = ChatRoomMsg.toModel(jsonDecode(loadedData)['Message']);
          ChatRoomModel chatRoomModel = ref.read(roomMessageProvider.notifier).state;
          chatRoomModel.chatRoomMsg.insert(0, tempchatRoomMessage);

          /// App最小化場合直接画面を更新する
          if (!inBackground) {
            updatePageMsg();
          }

        default:
          break;
      }
    });

    return _broadcastStream = _chatroomListChannel.stream;
  }

  void loadRoomData({required String loginUserUID}) {
    pageNum = pageNum + 1;
    Map<String, dynamic> map = {
      "method": "loadRoomMessage",
      "ip": APIHttpController.domainUrl,
      "roomid": enterRoomID,
      "userid": loginUserUID,
      "pageNumber": pageNum,
    };

    _chatroomListChannel.sink.add(jsonEncode(map));
  }

  Future<void> sendMessage({required String loginUserUID, required String message}) async {
    Map<String, dynamic> map = {
      "method": "sendMessage",
      "roomid": enterRoomID,
      "userid": loginUserUID,
      "message": message,
    };

    if (await FriendService().sendMessage(enterRoomID, loginUserUID, message)) {
      _chatroomListChannel.sink.add(jsonEncode(map));
    }
  }

  /// チャットルーム離れる
  void closeRoom() {
    print("chatRoom close enterRoomID : ${enterRoomID}");

    _broadcastStream = null;
    roomAllPage = -1;
    enterRoomID = -1;
    ref.read(loginUserInChatRoomId.notifier).update((state) => enterRoomID);
    pageNum = 0;
    ref.read(roomMessageProvider.notifier).update((state) => ChatRoomModel(chatRoomMsg: []));
    _chatroomListChannel.sink.close();
  }

  ///画面のメッセージ更新する
  void updatePageMsg() {
    ChatRoomModel chatRoomModel = ref.read(roomMessageProvider.notifier).state;
    ref.read(roomMessageProvider.notifier).update((state) => chatRoomModel);

    List<String> userIds = chatRoomModel.members.map((e) => e.replaceAll("\"", "")).toList();

    ChatWSModel().sendMsg(userIds, enterRoomID);

    if (insendMsgCount < 20) {
      insendMsgCount++;
    } else {
      pageNum++;
      insendMsgCount = 0;
    }
    render();
  }

  /// App
  void screenOFF() {
    if (!isOffScreen) {
      closeRoom();
      isOffScreen = true;
    }
  }

  /// App最小化
  void appToBackground() {
    if (!isOffScreen) {
      inBackground = true;
    }
  }

  Future<void> offScreenRetrun(
      {required String userId, required FriendListModel roomData, required ScrollController scrollController}) async {
    _chatroomListChannel = IOWebSocketChannel.connect(_channelRoomUrl);

    UserBlockStatusType userBlockStatusType = await HomeGlobalViewModel().getUserBlockStatus(userData: roomData.userData);
    isBlocked = userBlockStatusType == UserBlockStatusType.blocked;

    print("chatRoom isOffScreen reConnect $_channelRoomUrl");
    await _chatroomListChannel.ready;

    enterRoomID = roomData.roomId;
    ref.read(loginUserInChatRoomId.notifier).update((state) => enterRoomID);

    Map<String, dynamic> map = {
      "method": "connect",
      "ip": APIHttpController.domainUrl,
      "userid": userId,
      "roomid": enterRoomID,
      "pageNumber": pageNum,
    };

    _chatroomListChannel.sink.add(jsonEncode(map));
    stream();
    scrollController.jumpTo(0);
  }

  /// App最小化 > 戻る > WSもう一度繋がる > 画面のメッセージを更新する
  Future<void> appRetrun({required String userId, required FriendListModel roomData}) async {
    UserBlockStatusType userBlockStatusType = await HomeGlobalViewModel().getUserBlockStatus(userData: roomData.userData);
    isBlocked = userBlockStatusType == UserBlockStatusType.blocked;

    print("chatRoom inBackground reConnect $_channelRoomUrl");

    /// WS クローズ
    _chatroomListChannel.sink.close();
    _broadcastStream = null;
    _chatroomListChannel = IOWebSocketChannel.connect(_channelRoomUrl);
    await _chatroomListChannel.ready;

    Map<String, dynamic> map = {
      "method": "reConnect",
      "userid": userId,
      "roomid": roomData.roomId,
    };

    /// WSもう一度繋がる
    _chatroomListChannel.sink.add(jsonEncode(map));
    stream();

    ///  画面のメッセージを更新する
    inBackground = false;
    updatePageMsg();
  }

  /// 正確的にクロスチャットルーム（chat_roomのdispose発生用に）
  void deleteFriendClospage() {
    closePage();
    HomeGlobalViewModel().popUntiltFirst();
  }
}
