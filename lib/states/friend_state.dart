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
  TextEditingController friendListFilterInput = TextEditingController();
  bool _isSendMessage = false, isFriend = false;
  List<String> members = [];

  TextEditingController messageInput = TextEditingController();
  int roomId = -1;
  LoginUser ohterUserData = LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0);
  List<ChatRoomMessageModel> chatRoomMesaage = [];
  bool isLoading = true;
  String channelListUrl;
  int pageNumber = 0;
  int pageCount = 0;

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
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "checkIsFriend","members" : $usersListTemp}');
  }

  void addFriend(List<String> usersList) {
    List<String> usersListTemp = [];
    //index 0 : 使用者自己, index 1 : 對方
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "addFriend", "members" : $usersListTemp}');
    isFriend = true;
    notifyListeners();
  }

  void deleteFriend(List<String> usersList, int roomId) {
    List<String> usersListTemp = [];
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink.add('{"method" : "deleteFriend", "members" : $usersListTemp, "roomid" : $roomId}');
  }

  Future<void> openRoom(int roomId) async {
    this.roomId = roomId;
    isLoading = true;
    pageNumber = 0;
    pageCount = 0;
    chatRoomMesaage = [];
    isDataAddLoding = false;
    notifyListeners();
  }

  Future<void> initialRoomListener(int roomId, String userId) async {
    Future<void> initialConnect() async {
      print("initialConnect");
      _chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
      await _chatRoomChannel.ready;
      _chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : $roomId , "userid" : "$userId" , "pageNumber" : 0}');
    }

    await initialConnect();

    _chatRoomChannel.stream.listen((event) {
      String requestData = (event as String);

      if (requestData.contains("load:")) {
        var loadedData = (event).substring("load:".length);
        List<ChatRoomMessageModel> tempchatRoomMessage = (jsonDecode(loadedData) as List<dynamic>).map((e) {
          return ChatRoomMessageModel.fromJson(e);
        }).toList();
        for (var element in tempchatRoomMessage) {
          chatRoomMesaage = [...chatRoomMesaage, element];
        }
        isDataAddLoding = false;
      } else if (requestData.contains("connect:")) {
        var loadedData = (event).substring("connect:".length);

        for (var element in (jsonDecode(loadedData)["Members"] as List<dynamic>)) {
          members = [...members, "\"$element\""];
        }
        chatRoomMesaage = (jsonDecode(loadedData)['Message'] as List<dynamic>).map((e) {
          return ChatRoomMessageModel.fromJson(e);
        }).toList();
        pageCount = jsonDecode(loadedData)['PageCount'];
        isLoading = false;
      } else if (requestData.contains("sendMessage:")) {
        var loadedData = (event).substring("sendMessage:".length);
        ChatRoomMessageModel tempchatRoomMessage = ChatRoomMessageModel.fromJson(jsonDecode(loadedData)['Message']);
        chatRoomMesaage.insert(0, tempchatRoomMessage);
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
    notifyListeners();
    Navigator.of(context).pop();
  }
}
