import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/states/services/db_service.dart';
import 'package:web_socket_channel/io.dart';
import '../global.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class FriendState extends ChangeNotifier {
  late IOWebSocketChannel _friendListChannel, _chatRoomChannel;
  final DBService _dbService = DBService();
  List<FriendListModel> friendList = [];
  TextEditingController friendListFilterInput = TextEditingController();
  bool isFriend = false;
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
      _friendListChannel.sink.add('{"method" : "connect" , "ip" : "$ip:$port" , "userid" : "$uid"}');
    }

    await initialConnect();

    _friendListChannel.stream.listen((event) async {
      print(event);
      if (event == "is already Friend") {
        isFriend = true;
        print("isFriend check $isFriend");
      } else {
        Map<String, dynamic> requestMapData = jsonDecode((event));
        String searchUrl = requestMapData['apiUrl'];
        final uri = Uri.parse(searchUrl);
        try {
          var response = await http.get(uri);
          if (response.statusCode != 404) {
            var loadedData = utf8.decode(response.bodyBytes);
            List<FriendListModel> tempfriendList = (jsonDecode(loadedData) as List<dynamic>).map((e) {
              return FriendListModel.fromJson(e);
            }).toList();
            tempfriendList.sort((a, b) => DateTime.parse(a.sentAt ?? "1997-01-01T00:00:00.000+00:00")
                .compareTo(DateTime.parse(b.sentAt ?? "1997-01-01T00:00:00.000+00:00")));
            tempfriendList = tempfriendList.map((e) {
              return friendListFormatDate(e);
            }).toList();
            friendList = tempfriendList.reversed.toList();
          }
        } catch (e) {
          print(e);
        }
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
    _friendListChannel.sink.add('{"method" : "addFriend", "ip" : "$ip:$port" , "members" : $usersListTemp}');
    isFriend = true;
    notifyListeners();
  }

  void deleteFriend(List<String> usersList, int roomId) {
    List<String> usersListTemp = [];
    usersList.forEach((element) {
      usersListTemp = [...usersListTemp, "\"$element\""];
    });
    _friendListChannel.sink
        .add('{"method" : "deleteFriend", "ip" : "$ip:$port" , "members" : $usersListTemp, "roomid" : $roomId}');
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
          final uri = Uri.parse(searchUrl);
          try {
            var response = await http.get(uri);
            if (response.statusCode != 404) {
              var loadedData = utf8.decode(response.bodyBytes);
              for (var element in (jsonDecode(loadedData)["Members"] as List<dynamic>)) {
                members = [...members, "\"$element\""];
              }
              chatRoomMesaage = (jsonDecode(loadedData)['Message'] as List<dynamic>).map((e) {
                return ChatRoomMessageModel.fromJson(e);
              }).toList();
              pageCount = jsonDecode(loadedData)['PageCount'];
              isLoading = false;
            }
          } catch (e) {
            print(e);
          }
        case "load":
          String searchUrl = requestMapData['apiUrl'];
          final uri = Uri.parse(searchUrl);

          try {
            var response = await http.get(uri);
            if (response.statusCode != 404) {
              var loadedData = utf8.decode(response.bodyBytes);
              List<ChatRoomMessageModel> tempchatRoomMessage = (jsonDecode(loadedData)['Message'] as List<dynamic>).map((e) {
                return ChatRoomMessageModel.fromJson(e);
              }).toList();
              for (var element in tempchatRoomMessage) {
                chatRoomMesaage = [...chatRoomMesaage, element];
              }
              isDataAddLoding = false;
            }
          } catch (e) {
            print(e);
          }
        case "sendMessage":
          var loadedData = event;
          ChatRoomMessageModel tempchatRoomMessage = ChatRoomMessageModel.fromJson(jsonDecode(loadedData)['Message']);
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
    String searchUrl = 'http://$ip:$port/chat/createMessage/$roomId';

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = jsonEncode({"userId": userId, "message": message});

    await http.put(uri, headers: headers, body: body).then((value) {
      var result = utf8.decode(value.bodyBytes);
      print("message result ${result}");
      if (result == "true") {
        _chatRoomChannel.sink
            .add('{"method" : "sendMessage" , "roomid" : $roomId , "userid" : "$userId" , "message" : "$message"}');
      } else {
        print("Message Insert Failed");
      }
    });
  }

  void closeRoom({required BuildContext context}) {
    _chatRoomChannel.sink.close();
    notifyListeners();
    Navigator.of(context).pop();
  }
}
