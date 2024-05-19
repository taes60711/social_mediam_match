import 'dart:convert';
import 'dart:developer';
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

  final GlobalKey<ScaffoldState> key = GlobalKey();
  TextEditingController messageInput = TextEditingController();
  int roomId = -1;
  LoginUser ohterUserData = LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0);
  List<ChatRoomMessageModel> chatRoomMesaage = [];

  String channelListUrl;
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
          String userUID = element['memberId'];
          LoginUser? userData = await _dbService.getUserData(userUID);
          print("lastMessage ${element['lastMessage']}");
          tempfriendList.add(FriendListModel.fromJson(element, userData));
        });
        friendList = tempfriendList;
      }

      notifyListeners();
    });
  }

  //ユーザ友達かどうか確認する
  void UserDetailPageClose(String uid) {
    isFriend = false;
    notifyListeners();
  }

  void closefriendList() {
    _friendListChannel.sink.close();
  }

  void checkIsFriend(List<String> usersList) {
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

  Future<void> openRoom(int roomId, LoginUser choicedRoomUser) async {
    Future<void> initialConnect() async {
      _chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await _chatRoomChannel.ready;
      _chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : $roomId}');
      this.roomId = roomId;
      ohterUserData = choicedRoomUser;
      notifyListeners();
    }

    await initialConnect();

    _chatRoomChannel.stream.listen((event) {
      (jsonDecode(event)["Members"] as List<dynamic>).forEach((element) {
        members = [...members, "\"$element\""];
      });
      chatRoomMesaage = (jsonDecode(event)['Message'] as List<dynamic>).map((e) {
        return ChatRoomMessageModel.fromJson(e);
      }).toList();
      notifyListeners();

      if (_isSendMessage) {
        _friendListChannel.sink.add('{"method" : "sendMessage" , "members" : $members}');
        _isSendMessage = false;
      }
    });
  }

  void closeRoom() {
    _chatRoomChannel.sink.close();
  }

  void sendMessage(int roomId, String userId, String message) {
    messageInput.text = "";
    notifyListeners();
    _chatRoomChannel.sink.add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
    _isSendMessage = true;
  }
}
