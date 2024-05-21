import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/states/services/db_service.dart';
import 'package:web_socket_channel/io.dart';
import '../global.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class FriendState extends ChangeNotifier {
  late IOWebSocketChannel _friendListChannel, _chatRoomChannel;
  final DBService _dbService = DBService();
  List<FriendListModel> friendList = [];

  bool _isSendMessage = false, isFriend = false;
  List<String> members = [];

  TextEditingController messageInput = TextEditingController();
  int roomId = -1;
  LoginUser ohterUserData = LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0);
  List<ChatRoomMessageModel> chatRoomMesaage = [];
  bool isLoading = false;
  String channelListUrl;
  int pageNumber = 0;

  FriendState({required this.channelListUrl});

  void friendListConnect(String uid) async {
    Future<void> initialConnect() async {
      _friendListChannel = IOWebSocketChannel.connect(channelListUrl);
      print("friendList connect");
      await _friendListChannel.ready;
      _friendListChannel.sink.add('{"method" : "connect" , "userid" : "$uid"}');
    }

    await initialConnect();

    _friendListChannel.stream.listen((event) async {
      if (event == "is already Friend") {
        isFriend = true;
        print("isFriend check $isFriend");
      } else if (event != "" && event != "is already Friend") {
        List<dynamic> firends = jsonDecode(event) as List<dynamic>;
        List<FriendListModel> tempfriendList = [];
        await Future.forEach(firends, (element) async {
          print("createdBy ${element['createdBy']} lastMessage ${element['lastMessage']} time ${element['sentAt']}");
          String userUID = element['memberId'] != uid ? element['memberId'] : element['createdBy'];
          LoginUser? userData = await _dbService.getUserData(userUID);
          tempfriendList.add(FriendListModel.fromJson(element, userData));
        });
        tempfriendList.sort((a, b) => DateTime.parse(a.sentAt ?? "1997-01-01T00:00:00.000+00:00")
            .compareTo(DateTime.parse(b.sentAt ?? "1997-01-01T00:00:00.000+00:00")));
        tempfriendList = tempfriendList.map((e) {
          return friendListFormatDate(e);
        }).toList();
        friendList = tempfriendList.reversed.toList();
      }

      notifyListeners();
    });
  }

  void closefriendList() {
    _friendListChannel.sink.close();
  }

  //ユーザ友達かどうか確認する
  void checkIsFriend(List<String> usersList) {
    isFriend = false;
    Future.delayed(Duration.zero).then((value) => notifyListeners());
    List<String> usersListTemp = [];
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "checkIsFriend","members" : $usersListTemp}');
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "addFriend","members" : $usersListTemp}');
    isFriend = true;
    notifyListeners();
  }

  Future<void> openRoom(int roomId) async {
    this.roomId = roomId;
    isLoading = false;
    notifyListeners();
  }

  Future<void> initialRoomListener(int roomId, String userId) async {
    Future<void> initialConnect() async {
      _chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await _chatRoomChannel.ready;
      _chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : $roomId , "userid" : "$userId" , "pageNumber" : 0}');
    }

    await initialConnect();

    _chatRoomChannel.stream.listen((event) {
      if ((event as String).contains("load:")) {
        var loadedData = (event).substring("load:".length);
        List<ChatRoomMessageModel> tempchatRoomMessage = (jsonDecode(loadedData) as List<dynamic>).map((e) {
          return ChatRoomMessageModel.fromJson(e);
        }).toList();
        tempchatRoomMessage.forEach((element) {
          chatRoomMesaage = [...chatRoomMesaage, element];
        });
        isDataAddLoding = false;
      } else {
        pageNumber = 0;
        Future.delayed(Duration.zero).then((value) => notifyListeners);
        (jsonDecode(event)["Members"] as List<dynamic>).forEach((element) {
          members = [...members, "\"$element\""];
        });
        chatRoomMesaage = (jsonDecode(event)['Message'] as List<dynamic>).map((e) {
          return ChatRoomMessageModel.fromJson(e);
        }).toList();
        if (!isLoading) {
          isLoading = true;
        }
      }
      notifyListeners();

      if (_isSendMessage) {
        //友だちリストにラストメッセージ送る
        _friendListChannel.sink.add('{"method" : "sendMessage" , "members" : $members}');
        _isSendMessage = false;
      }
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
    _chatRoomChannel.sink
        .add('{"method" : "loadRoomMessage" , "roomid" : $roomId  , "userid" : "$userId" , "pageNumber" : $pageNumber}');
  }

  void sendMessage(int roomId, String userId, String message) {
    messageInput.text = "";
    notifyListeners();
    _chatRoomChannel.sink.add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
    _isSendMessage = true;
  }

  void closeRoom({required BuildContext context}) {
    _chatRoomChannel.sink.close();
    chatRoomMesaage = [];
    isDataAddLoding = false;
    notifyListeners();
    Navigator.of(context).pop();
  }
}
