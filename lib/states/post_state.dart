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
  bool isFirstLoading = false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  LoginUser? otherUser;

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

  Future<void> getPostCommentData(int postId) async {
    List<PostCommentModel> tempPostCommentData = await _dbService.getPostCommentData(postId);

    tempPostCommentData.forEach((e) {
      postCommentData = [...postCommentData, e];
    });
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

  Future<void> createPostComment(int postId, String userUid, String message) async {
    try {
      await _dbService.createPostComment(postId, userUid, message);

      DateTime dateUtc = DateTime.now().toUtc();
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
      String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

      PostCommentModel tempPostCommentData =
          PostCommentModel(postId: postId, userUid: userUid, message: message, postTime: formattedTime);
      postCommentData.insert(0, tempPostCommentData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void openDrawer(LoginUser otherUser) {
    this.otherUser = otherUser;

    notifyListeners();
    globalKey.currentState!.openEndDrawer();
  }
}
