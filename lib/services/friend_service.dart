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

  Future<bool> sendMessage(int roomId, String userId, String message) async {
    Map<String, dynamic> body = {"userId": userId, "message": message};

    String responseData = await apiPush("/chat/createMessage/$roomId", body: body);

    print("sendMessage : $responseData");

    return responseData != "null" ? true : false;
  }
}
