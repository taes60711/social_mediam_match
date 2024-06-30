import 'package:social_mediam_match/services/api_client.dart';

import '../global.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService extends ApiClient {
  PostService() : super(overrideIp: "$ip:$port/posts");

  Future<List<PostCommentTextEditorModel>> getPostCommentData(int page, int size, int postId) async {
    List<PostCommentTextEditorModel> requestPostCommentData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getPostComment/$postId', paramters: paramters);

      requestPostCommentData = await handleResponse<PostCommentTextEditorModel>(
        responseData,
        model: PostCommentTextEditorModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostCommentData;
  }

  ///フィルターした文章取得する
  Future<List<PostModel>> getPostByTextFilter(int page, int size, String inputedText) async {
    List<PostModel> requestPostDataByNew = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'inputedText': inputedText,
    };

    try {
      String responseData = await apiGet('/getPostByTextFilter', paramters: paramters);

      requestPostDataByNew = await handleResponse<PostModel>(
        responseData,
        model: PostModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByNew;
  }

  ///看板文章取得する
  Future<List<PostModel>> getPostByType(int page, int size, int type) async {
    List<PostModel> requestPostDataByNew = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getPostsByType/$type', paramters: paramters);

      requestPostDataByNew = await handleResponse<PostModel>(
        responseData,
        model: PostModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByNew;
  }

  ///最新文章取得する
  Future<List<PostModel>> getNewPosts(int page, int size) async {
    List<PostModel> requestPostDataByNew = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getNewPosts', paramters: paramters);

      requestPostDataByNew = await handleResponse<PostModel>(
        responseData,
        model: PostModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByNew;
  }

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

  ///文章View数更新
  Future<bool> updatePostViewCount(int postId) async {
    String responseData = await apiPush("/moveToPost/$postId", body: {});

    print("updatePostViewCount $responseData");

    return responseData != "null" ? true : false;
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

  /// 文章削除
  Future<bool> deletePost(int postId) async {
    String responseData = await apiPush("/delete/$postId", body: {});

    print("deletePost $responseData");

    return responseData != "null" ? true : false;
  }

  /// 文章作成
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

  /// 入っている文章”いいね”したことがあるチェック
  Future<bool> checkIsPostGood({required int postId, required String userUID}) async {
    bool ischeck = false;
    try {
      String responseData = await apiGet('/checkIsPostGood/$postId/$userUID');

      print("checkIsPostGood $responseData");
      if (responseData == "true") {
        ischeck = true;
      }
    } catch (e) {
      onRequestFailed();
    }

    return ischeck;
  }

  /// 文章”いいね”更新
  Future<bool> updatePostGood(int postId, {String? userUID}) async {
    Map<String, dynamic> body = {};

    if (userUID != null) {
      body = {"goodedUserUID": userUID};
      print("Good");
    }

    String responseData = await apiPush("/updatePostGood/$postId", body: body);

    print("updatePost $responseData");

    return responseData != "null" ? true : false;
  }
}
