import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/services/api_client.dart';
import 'package:social_mediam_match/services/token_service.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService extends ApiClient {
  PostService() : super(overrideBranch: "/posts");

  TokenService tokenService = TokenService();

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
        FontAwesomeIcons.code,
        FontAwesomeIcons.globe,
        FontAwesomeIcons.microchip,
        FontAwesomeIcons.headSideVirus
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
  Future<List<PostModel>> getPostDataByViewer(int page, int size, {required String userId}) async {
    List<PostModel> requestPostDataByUID = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'uid': userId,
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

  /// 類別文章取得する
  Future<List<PostModel>> getPostByType(int page, int size, int type, {String? userId}) async {
    List<PostModel> requestPostDataByNew = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'uid': userId == "guest" ? "" : userId,
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
  Future<List<PostModel>> getNewPosts(int page, int size, {required String userId}) async {
    List<PostModel> requestPostDataByNew = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'uid': userId == "guest" ? "" : userId,
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
      onRequestFailed(content: "該文章已被刪除");
    }

    return requestPostDataByUID;
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

  ///MARK: 文章View数更新
  Future<bool> updatePostViewCount(int postId) async {
    String responseData = await apiPush("/moveToPost/$postId", body: {});

    print("updatePostViewCount $responseData");

    return responseData != "null" ? true : false;
  }

  ///MARK: 文章作成
  Future<int> createPost({
    required String uid,
    required String message,
    required String fileMessage,
    required int type,
  }) async {
    Map<String, dynamic> body = {
      "createdBy": uid,
      "mainMessage": message,
      "fileMessage": fileMessage,
      "type": type,
    };

    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/createPost",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("createPost ${response.statusCode}");

    if (response.statusCode != "200") {
      return -1;
    }

    return response.data['postIndex'];
  }

  /// 文章編集
  Future<bool> updatePost({
    required String uid,
    required int postId,
    required String mainMessage,
    required String fileMessage,
  }) async {
    Map<String, dynamic> body = {
      "mainMessage": mainMessage,
      "fileMessage": fileMessage,
    };

    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/update/$postId",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("updatePost ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }
    return true;
  }

  /// 文章削除
  Future<bool> deletePost({
    required int postId,
    required String uid,
  }) async {
    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/delete/$postId",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: {},
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("deletePost ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }

    return true;
  }

  /// 文章”いいね”更新
  Future<bool> updatePostGood(
    int postId, {
    String? userUID,
    required WidgetRef ref,
  }) async {
    Map<String, dynamic> body = {};

    if (userUID != null) {
      body = {"goodedUserUID": userUID};
      print("Good");
    }

    ProfileData userData = ref.watch(loginUserData);

    String token = await tokenService.getToken(userId: userData.uid);

    String responseData = await apiPush(
      "/updatePostGood/$postId",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("updatePostGood ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }

    return true;
  }

  ///MARK: 文章の”コメント” 作成
  Future<int> createPostComment({
    required int postUID,
    required String userUID,
    required String message,
  }) async {
    Map<String, dynamic> body = {
      "postId": postUID,
      "userUid": userUID,
      "message": message,
    };

    String token = await tokenService.getToken(userId: userUID);

    String responseData = await apiPush(
      "/createPostComment",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("createPostComment ${response.statusCode}");

    if (response.statusCode != "200") {
      return -1;
    }

    return response.data['postCommentIndex'];
  }

  /// 文章 ”コメント” 編集
  Future<bool> updatePostComment({
    required String uid,
    required int id,
    required String mainMessage,
  }) async {
    Map<String, dynamic> body = {};

    body = {
      "id": id,
      "message": mainMessage,
    };

    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/updatePostComment/$id",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("updatePostComment ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }

    return true;
  }

  /// 文章 ”コメント” 削除
  Future<bool> deletePostComment({required String uid, required int id}) async {
    Map<String, dynamic> body = {};

    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/deletePostComment/$id",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: body,
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("deletePostComment ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }

    return true;
  }
}
