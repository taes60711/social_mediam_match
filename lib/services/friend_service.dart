import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/services/api_client.dart';
import '../models/friend_model.dart';

class FriendService extends ApiClient {
  ///チャットルームのフレンドリスト取得する
  ///apiUrl: websocketからAPIURL
  Future<List<FriendListModel>> getFriendList(String apiUrl) async {
    List<FriendListModel> friendList = [];

    try {
      String url = apiUrl.substring("http://$ip:$port".length);
      String responseData = await apiGet(url);

      friendList = await handleResponse<FriendListModel>(
        responseData,
        model: FriendListModel.toModel,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return friendList;
  }

  Future<ChatRoomModel> getChatRoomMsg(String apiUrl) async {
    ChatRoomModel roomMsg = ChatRoomModel(chatRoomMsg: []);

    try {
      String url = apiUrl.substring("http://$ip:$port".length);
      String responseData = await apiGet(url);

      roomMsg = await handleResponse<ChatRoomModel>(
        responseData,
        model: ChatRoomModel.toModel,
      );
    } catch (e) {
      onRequestFailed();
    }

    return roomMsg;
  }

  /// フレンドチェク
  Future<bool> getIsFrined({required String userUID, required String ohterUserUID}) async {
    Map<String, dynamic> paramters = {
      "useUId": userUID,
      "otherUserUId": ohterUserUID,
    };

    String responseData = await apiGet("/chat/getIsFriend", paramters: paramters);

    print("getIsFriend $responseData");

    return responseData == "true" ? true : false;
  }

  ///メッセージ送る
  ///roomid: チャットルームのID userId: ログインユーザID　message:打ったメッセージ
  Future<bool> sendMessage(int roomId, String userId, String message) async {
    Map<String, dynamic> body = {"userId": userId, "message": message};

    String responseData = await apiPush("/chat/createMessage/$roomId", body: body);

    print("sendMessage : $responseData");

    return responseData != "null" ? true : false;
  }

  Future<bool> deleteFriend(int roomId, String userId) async {
    Map<String, dynamic> body = {};

    String responseData = await apiPush("/chat/deleteFriend/$roomId/$userId", body: body);

    print("deleteFriend : $responseData");

    return responseData != "null" ? true : false;
  }

  ///roomid: チャットルームのID userId: ログインユーザID　message:打ったメッセージ
  Future<bool> updateUnreadCount(int roomId, String userId, int unreadCount) async {
    String responseData = await apiPush("/chat/updateRoomListUnreadCount/$roomId/$userId/$unreadCount", body: {});

    print("updateRoomListUnreadCount : $responseData");

    return responseData != "null" ? true : false;
  }
}
