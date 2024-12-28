import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/services/api_client.dart';

import '../global.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService extends ApiClient {
  PostService() : super(overrideIp: "$ip:$port/posts");

  ///MARK: 全て掲示板種類取得する
  Future<List<PostBoard>> getAllPostBoard() async {
    List<PostBoard> requestAllPostBoard = [];

    try {
      String responseData = await apiGet('/getAllPostBoard');
      print("responseData $responseData");
      requestAllPostBoard = await handleResponse<PostBoard>(
        responseData,
        model: PostBoard.toMap,
        isList: true,
      );

      List<IconData> boardIcon = [
        FontAwesomeIcons.commentDots,
        FontAwesomeIcons.wifi,
        FontAwesomeIcons.globe,
        FontAwesomeIcons.microchip,
        FontAwesomeIcons.code,
      ];

      requestAllPostBoard = requestAllPostBoard.asMap().entries.map((e) {
        int index = e.key;
        PostBoard value = e.value;
        value.iconData = boardIcon[index];
        return value;
      }).toList();
    } catch (e) {
      onRequestFailed();
    }

    return requestAllPostBoard;
  }

  ///MARK: 人気文章取得する
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

  /// フィルターした文章取得する
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

  /// 看板文章取得する
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

  /// 最新文章取得する
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

  /// My投稿取得する
  Future<List<PostModel>> getPostDataByUID(int page, int size, ProfileData userData) async {
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

  //// 文章IDで文章内容を取得する
  Future<PostModel> getPostDataByPostId(int postId) async {
    PostModel requestPostDataByUID = PostModel();

    Map<String, dynamic> paramters = {
      'id': '$postId',
    };

    try {
      String responseData = await apiGet('/getPostsByPostId', paramters: paramters);

      requestPostDataByUID = await handleResponse<PostModel>(
        responseData,
        model: PostModel.toMap,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByUID;
  }

  ///MARK: 文章View数更新
  Future<bool> updatePostViewCount(int postId) async {
    String responseData = await apiPush("/moveToPost/$postId", body: {});

    print("updatePostViewCount $responseData");

    return responseData != "null" ? true : false;
  }

  ///MARK: 文章作成
  Future<int> createPost(String uid, String title, String message, int type) async {
    Map<String, dynamic> body = {
      "createdBy": uid,
      "title": title,
      "mainMessage": message,
      "type": type,
    };

    String responseData = await apiPush("/createPost", body: body);

    int index = int.parse(responseData);
    return index;
  }

  /// 文章編集
  Future<bool> updatePost({required int postId, required String title, required String mainMessage}) async {
    Map<String, dynamic> body = {
      "id": postId,
      "title": title,
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

  ///MARK: 文章”コメント”取得する
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

  ///MARK: 文章 ”コメント” 作成
  Future<int> createPostComment({required int postUID, required String userUID, required String message}) async {
    Map<String, dynamic> body = {};

    body = {"postId": postUID, "userUid": userUID, "message": message};

    String responseData = await apiPush("/createPostComment", body: body);

    int index = int.parse(responseData);
    return index;
  }

  /// 文章 ”コメント” 編集
  Future<bool> updatePostComment({required int id, required String mainMessage}) async {
    Map<String, dynamic> body = {};

    body = {
      "id": id,
      "message": mainMessage,
    };

    String responseData = await apiPush("/updatePostComment/$id", body: body);

    print("updatePostComment $responseData");

    return responseData != "null" ? true : false;
  }

  /// 文章 ”コメント” 削除
  Future<bool> deletePostComment({required int id}) async {
    Map<String, dynamic> body = {};

    String responseData = await apiPush("/deletePostComment/$id", body: body);

    print("deletePostComment $responseData");

    return responseData != "null" ? true : false;
  }
}
