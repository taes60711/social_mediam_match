import 'package:social_mediam_match/services/api_client.dart';

import '../global.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService extends ApiClient {
  PostService() : super(overrideIp: "$ip:$port/posts");

  ///人気文章取得する
  Future<List<PostModel>> getPostDataByViewer(int page, int size) async {
    List<PostModel> requestPostDataByUID = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getAll', paramters: paramters);

      requestPostDataByUID = await handleResponse<PostModel>(
        responseData,
        model: PostModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByUID;
  }

  ///My投稿取得する
  Future<List<PostModel>> getPostDataByUID(int page, int size, LoginUser userData) async {
    List<PostModel> requestPostDataByUID = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getPostsByUser/${userData.uid}', paramters: paramters);

      requestPostDataByUID = await handleResponse<PostModel>(
        responseData,
        model: PostModel.myPostToMap,
        isList: true,
      );

      ///My投稿のAPIからUserDataなし場合使用する
      requestPostDataByUID.map((e) => PostModel.noUserDataPostAddUserData(noUserDatPost: e, userData: userData)).toList();
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByUID;
  }

  ///文章更新
  Future<bool> updatePost({required int postId, required String mainMessage}) async {
    Map<String, dynamic> body = {
      "id": postId,
      "mainMessage": mainMessage,
    };

    String responseData = await apiPush("/update/$postId", body: body);

    print("updatePost $responseData");

    return responseData != "null" ? true : false;
  }

  ///文章削除
  Future<bool> deletePost(int postId) async {
    String responseData = await apiPush("/delete/$postId", body: {});

    print("deletePost $responseData");

    return responseData != "null" ? true : false;
  }

  ///文章作成
  Future<bool> createPost(String uid, String title, String message, int type) async {
    Map<String, dynamic> body = {
      "createdBy": uid,
      "title": title,
      "mainMessage": message,
      "type": type,
    };

    String responseData = await apiPush("/createPost", body: body);

    print("updatePost $responseData");

    return responseData != "null" ? true : false;
  }
}
