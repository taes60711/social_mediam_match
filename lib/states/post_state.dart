import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

import '../models/user_model.dart';

class PostState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<PostModel> postData = [];
  List<PostCommentModel> postCommentData = [];
  TextEditingController postCommentInput = TextEditingController();
  bool isFirstLoading = false, isPostCommentLoading = false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  String endDrawerType = "";
  PostModel? choicedPostData;
  LoginUser? otherUser;

  List<PostModel> myAllPosts = [];
  PostModel? choicedPost;
  bool myPostsIsFirstLoading = false;
  GlobalKey<ScaffoldState> myPostsGlobalKey = GlobalKey();
  TextEditingController messageInput = TextEditingController();

  Future<void> getPostDataByUID(LoginUser userData) async {
    try {
      List<PostModel> tempPostsData = [];
      tempPostsData = await _dbService.getPostDataByUID(userData);

      myAllPosts = tempPostsData;
      // tempPostsData.forEach((e) {
      //   myAllPosts = [...myAllPosts, e];
      // });
      isFirstLoading = false;
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

  void postOnChange(PostModel choicedPost) {
    this.choicedPost = choicedPost;
    Future.delayed(Duration.zero).then((value) => notifyListeners());
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
      postCommentData = [...postCommentData, e];
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

      PostCommentModel tempPostCommentData = PostCommentModel(
          postId: postId, userUid: commentUser.uid, message: message, postTime: formattedTime, commentUserInfo: commentUser);
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
