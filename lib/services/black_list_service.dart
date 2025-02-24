import '../models/BlockUser_model.dart';
import 'api_client.dart';

class BlackListService extends ApiClient {
  BlackListService() : super(overrideBranch: "/blacklist");

  Future<List<BlockUser>> getBlockUserList(int page, int size, {required String userUID}) async {
    List<BlockUser> requestAllCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'userId': userUID,
    };

    try {
      String responseData = await apiGet('/getBlockedList', paramters: paramters);

      requestAllCourseData = await handleResponse<BlockUser>(
        responseData,
        model: BlockUser.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestAllCourseData;
  }

  ///Addブラックリスト
  Future<bool> addBlackUserToList({required String uid, required String blockUID}) async {
    Map<String, dynamic> body = {
      "uid": uid,
      "block_uid": blockUID,
    };

    String responseData = await apiPush('/addUserToBlackList', body: body);

    print("addBlackUserToList : $responseData");

    return responseData != "null" ? true : false;
  }

  ///Deleteブラックリスト
  Future<bool> deleteBlackUserFromList({required String uid, required String blockUID}) async {
    Map<String, dynamic> body = {
      "uid": uid,
      "block_uid": blockUID,
    };

    String responseData = await apiPush('/deleteUserFromBlackList', body: body);

    print("deleteUserFromBlackList : $responseData");

    return responseData != "null" ? true : false;
  }

  Future<String> isUserBlocked({required String uid, required String blockUID}) async {
    Map<String, dynamic> body = {
      "uid": uid,
      "block_uid": blockUID,
    };

    String responseData = await apiPush('/isUserBlocked', body: body);

    print("isUserBlocked : $responseData");

    if (responseData == "block") {
      return "block";
    }
    if (responseData == "blocked") {
      return "blocked";
    }
    if (responseData == "none") {
      return "none";
    }

    return "failed";
  }
}
