import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/services/friend_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../components/utilities/endDrawers/chat_room_end_drawer.dart';
import '../components/utilities/endDrawers/user_detail_end_drawer.dart';
import '../global.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class WSClient {
  late WebSocketChannel channel;
  final String _ip;
  WSClient({String? ip}) : _ip = ip ?? "";

  Future<void> connect(Map<String, dynamic> pushParam) async {
    channel = IOWebSocketChannel.connect(_ip);
    await channel.ready;
    wsPush(pushParam: pushParam);
  }

  void close() {
    channel.sink.close();
  }

  void wsPush({required Map<String, dynamic> pushParam}) {
    channel.sink.add(jsonEncode(pushParam));
  }

  Stream<String> wsListner() {
    return channel.stream.map((event) {
      return event;
    });
  }
}

class FriendListService extends WSClient {
  FriendListService() : super(ip: channelListUrl);
}

class FriendProvider extends ChangeNotifier {
  late IOWebSocketChannel _friendListChannel;
  late IOWebSocketChannel _chatRoomChannel;
  List<FriendListModel> friendList = [];
  TextEditingController friendListFilterInput = TextEditingController();
  bool isFriend = false;
  List<String> members = [];

  TextEditingController messageInput = TextEditingController();
  int roomId = -1;
  LoginUser ohterUserData = LoginUser();
  List<ChatRoomMsg> chatRoomMesaage = [];
  bool isLoading = true;

  int pageNumber = 0;
  int pageCount = 0;

  FriendListService friendListService = FriendListService();

  void friendListConnect(String uid) async {
    Future<void> initialConnect() async {
      _friendListChannel = IOWebSocketChannel.connect(channelListUrl);
      print("friendList connect");
      await _friendListChannel.ready;

      Map<String, dynamic> map = {
        "method": "connect",
        "ip": "$ip:$port",
        "userid": uid,
      };

      _friendListChannel.sink.add(jsonEncode(map));
    }

    await initialConnect();

    _friendListChannel.stream.listen((event) async {
      print(event);
      if (event == "is already Friend") {
        isFriend = true;
        print("isFriend check $isFriend");
      } else {
        String searchUrl = jsonDecode((event))['apiUrl'];
        List<FriendListModel> tempfriendList = await FriendService().getFriendList(searchUrl);
        String initDate = "1997-01-01T00:00:00.000+00:00";
        tempfriendList.sort((a, b) => DateTime.parse(a.sentAt ?? initDate).compareTo(DateTime.parse(b.sentAt ?? initDate)));
        tempfriendList = tempfriendList.map((e) {
          return friendListFormatDate(e);
        }).toList();
        friendList = tempfriendList.reversed.toList();
      }
      notifyListeners();
    });
  }

  void friendListFilterInputOnChange(String value) {
    friendListFilterInput.text = value;
    notifyListeners();
  }

  void closefriendList() {
    _friendListChannel.sink.close();
  }

  //ユーザ友達かどうか確認する
  void checkIsFriend(List<String> usersList) {
    isFriend = false;
    Future.delayed(Duration.zero).then((value) => notifyListeners());
    List<String> usersListTemp = [];
    for (var element in usersList) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    }
    _friendListChannel.sink.add('{"method" : "checkIsFriend","members" : $usersListTemp}');
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    //index 0 : 使用者自己, index 1 : 對方
    for (var element in usersList) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    }
    _friendListChannel.sink.add('{"method" : "addFriend", "ip" : "$ip:$port" , "members" : $usersListTemp}');
    isFriend = true;
    notifyListeners();
  }

  void deleteFriend(List<String> usersList, int roomId) {
    List<String> usersListTemp = [];
    for (var element in usersList) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    }
    _friendListChannel.sink
        .add('{"method" : "deleteFriend", "ip" : "$ip:$port" , "members" : $usersListTemp, "roomid" : $roomId}');
  }

  Future<void> initialRoomListener(int roomId, String userId) async {
    Future<void> initialConnect() async {
      print("initialConnect");
      _chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await _chatRoomChannel.ready;
      _chatRoomChannel.sink
          .add('{"method" : "connect" , "roomid" : $roomId , "ip" : "$ip:$port" , "userid" : "$userId" ,  "pageNumber" : 0}');
    }

    await initialConnect();

    _chatRoomChannel.stream.listen((event) async {
      Map<String, dynamic> requestMapData = jsonDecode((event as String));
      String listendMethod = requestMapData['method'];

      switch (listendMethod) {
        case "connect":
          String searchUrl = requestMapData['apiUrl'];

          ChatRoomModel chatRoomModel = await FriendService().getChatRoomMsg(searchUrl);

          pageCount = chatRoomModel.pageCount;
          members = chatRoomModel.members;
          chatRoomMesaage = chatRoomModel.chatRoomMsg;

          isLoading = false;

        case "load":
          String searchUrl = requestMapData['apiUrl'];
          ChatRoomModel chatRoomModel = await FriendService().getChatRoomMsg(searchUrl);
          chatRoomMesaage = [...chatRoomMesaage, ...chatRoomModel.chatRoomMsg];

          isDataAddLoding = false;

        case "sendMessage":
          var loadedData = event;
          ChatRoomMsg tempchatRoomMessage = ChatRoomMsg.toModel(jsonDecode(loadedData)['Message']);
          chatRoomMesaage.insert(0, tempchatRoomMessage);
          _friendListChannel.sink.add('{"method" : "sendMessage" , "ip" : "$ip:$port"  , "members" : $members}');
        default:
          break;
      }

      notifyListeners();
    });
  }

  bool isDataAddLoding = false;
  void dataAddLoadingChange(bool loading) {
    isDataAddLoding = loading;
    notifyListeners();
  }

  void loadMessage(int roomId, String userId, int number) {
    pageNumber = number + 1;
    notifyListeners();
    _chatRoomChannel.sink.add(
        '{"method" : "loadRoomMessage" , "roomid" : $roomId  , "ip" : "$ip:$port" , "userid" : "$userId" , "pageNumber" : $pageNumber}');
  }

  Future<void> sendMessage(int roomId, String userId, String message) async {
    messageInput.text = "";
    notifyListeners();

    if (await FriendService().sendMessage(roomId, userId, message)) {
      _chatRoomChannel.sink
          .add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
    }
  }

  Future<void> openRoom(int roomId, LoginUser roomMember) async {
    this.roomId = roomId;
    ohterUserData = roomMember;
    isLoading = true;
    pageNumber = 0;
    pageCount = 0;
    chatRoomMesaage = [];
    isDataAddLoding = false;
    notifyListeners();
  }

  UserDetailEndDrawerType endDrawerOpenInfo = UserDetailEndDrawerType.close;
  void changeEndDrawerStatus(UserDetailEndDrawerType status, LoginUser otherUser) {
    ohterUserData = otherUser;
    endDrawerOpenInfo = status;
    notifyListeners();
  }

  ChatRoomEndDrawerType chatRoomEndDrawerOpenInfo = ChatRoomEndDrawerType.close;
  void changeChatRoomEndDrawerStatus(ChatRoomEndDrawerType status) {
    if (status == ChatRoomEndDrawerType.close) {
      _chatRoomChannel.sink.close();
    }
    chatRoomEndDrawerOpenInfo = status;
    notifyListeners();
  }
}
