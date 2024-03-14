import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

class PostState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<PostModel> postData = [];
  List<PostCommentModel> postCommentData = [];

  Future<void> getPostData() async {
    List<PostModel> tempPostData = await _dbService.getPostData();

    tempPostData.forEach((e) {
      postData = [...postData, e];
    });
    notifyListeners();
  }

  Future<void> getPostCommentData(int postId) async {
    List<PostCommentModel> tempPostCommentData = await _dbService.getPostCommentData(postId);

    tempPostCommentData.forEach((e) {
      postCommentData = [...postCommentData, e];
    });
    notifyListeners();
  }
}
