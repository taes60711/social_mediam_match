import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

import '../models/user_model.dart';

class PostState extends ChangeNotifier {
  final DBService _dbService = DBService();
  int formIndex = -1;

  List<PostModel> postData = [];
  List<getPostCommentModel> postCommentData = [];
  List<TextEditingController> postCommentMessageController = [];
  TextEditingController postCommentInput = TextEditingController();
  bool isFirstLoading = true, isPostCommentLoading = false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  String endDrawerType = "";
  PostModel? choicedPostData;
  LoginUser? otherUser;

  List<PostModel> myAllPosts = [];
  PostModel? choicedPost;
  bool myPostsIsFirstLoading = false;
  GlobalKey<ScaffoldState> myPostsGlobalKey = GlobalKey();
  TextEditingController messageInput = TextEditingController();
  String myPostEndDrawerType = "";

  void forumPageChange(int index) {
    formIndex = index;
    notifyListeners();
  }

  void postOnChange(PostModel choicedPost, String endDrawerType) {
    myPostEndDrawerType = endDrawerType;
    this.choicedPost = choicedPost;
    Future.delayed(Duration.zero).then((value) => notifyListeners());
  }

  Future<void> getPostDataByUID(LoginUser userData, {required bool isFirstSearch}) async {
    try {
      List<PostModel> tempPostsData = [];
      if (isFirstSearch) {
        tempPostsData = await _dbService.getPostDataByUID(userData, isFirst: isFirstSearch);
      } else {
        tempPostsData = await _dbService.getPostDataByUID(userData);
      }
      tempPostsData.forEach((e) {
        myAllPosts = [...myAllPosts, e];
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostData(int postId) async {
    await _dbService.deletePost(postId);
    myAllPosts.remove(myAllPosts.where((element) => element.id == postId).first);
    notifyListeners();
  }

  Future<void> updatePostData(int postId, String updateMessage) async {
    await _dbService.updatePost(postId, updateMessage);
    int postIndex = myAllPosts.indexWhere((element) => element.id == postId);
    myAllPosts[postIndex].mainMessage = updateMessage;
    notifyListeners();
  }

  Future<void> getPostData({required bool isFirstSearch}) async {
    try {
      List<PostModel> tempPostData = [];
      if (isFirstSearch) {
        isFirstLoading = true;
        Future.delayed(Duration.zero).then((value) => notifyListeners());
        tempPostData = await _dbService.getPostData(isFirst: isFirstSearch);
      } else {
        tempPostData = await _dbService.getPostData();
      }

      tempPostData.forEach((e) {
        postData = [...postData, e];
      });
      isFirstLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> changePostComment(int uid, int index, String updatedMessage) async {
    await _dbService.updatePostComment(uid, updatedMessage);
    postCommentData[index].isEditor = false;
    postCommentData[index].message = updatedMessage;
    notifyListeners();
  }

  Future<void> editPostComment(int index) async {
    postCommentData[index].isEditor = !postCommentData[index].isEditor;
    notifyListeners();
  }

  Future<void> deletePostComment(int uId) async {
    await _dbService.deletePostComment(uId);
    postCommentData.remove(postCommentData.where((element) => element.uid == uId).first);
    postCommentMessageController.remove(postCommentData.where((element) => element.uid == uId).first);
    notifyListeners();
  }

  Future<void> getPostCommentData(int postId, {required bool isFirstSearch}) async {
    List<PostCommentModel> tempPostCommentData = [];
    if (isFirstSearch) {
      isPostCommentLoading = true;
      Future.delayed(Duration.zero).then((value) => notifyListeners());
      tempPostCommentData = await _dbService.getPostCommentData(postId, isFirst: isFirstSearch);
    } else {
      tempPostCommentData = await _dbService.getPostCommentData(postId);
    }

    tempPostCommentData.forEach((e) {
      postCommentData.add(
        getPostCommentModel(
            uid: e.uid,
            postId: postId,
            userUid: e.userUid,
            message: e.message,
            isEditor: false,
            postTime: e.postTime,
            commentUserInfo: e.commentUserInfo),
      );
      postCommentMessageController.add(TextEditingController());
    });
    isPostCommentLoading = false;
    notifyListeners();
  }

  Future<void> createPost(String userUid, String message) async {
    try {
      await _dbService.createPost(userUid, message);

      List<PostModel> tempPostData = await _dbService.getPostData(isFirst: true);
      postData = [];
      tempPostData.forEach((e) {
        postData = [...postData, e];
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createPostComment(int postId, String message, LoginUser commentUser) async {
    try {
      await _dbService.createPostComment(postId, commentUser.uid, message);

      DateTime dateUtc = DateTime.now().toUtc();
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
      String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

      getPostCommentModel tempPostCommentData = getPostCommentModel(
          postId: postId,
          userUid: commentUser.uid,
          message: message,
          postTime: formattedTime,
          commentUserInfo: commentUser,
          isEditor: false);
      postCommentMessageController.add(TextEditingController());
      postCommentData.insert(0, tempPostCommentData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void openDrawer(String endDrawerType, {LoginUser? otherUser, PostModel? choicedPostData}) {
    this.endDrawerType = endDrawerType;
    if (this.endDrawerType == "userDetail") {
      this.otherUser = otherUser;
    } else {
      this.choicedPostData = choicedPostData;
    }
    notifyListeners();
    globalKey.currentState!.openEndDrawer();
  }
}
