import 'package:flutter/material.dart';

import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
import '../../models/post_model.dart';

class PostCommentProvider extends ChangeNotifier {
  PostModel viewChoicedPost = PostModel();

  TextEditingController postCommentInput = TextEditingController();

  void afterPostCeate() {
    postCommentInput.text = "";
    notifyListeners();
  }

  void updateChoicedPostGoodCount({required bool isPlus}) {
    if (isPlus) {
      viewChoicedPost.good++;
    } else {
      viewChoicedPost.good--;
    }
    notifyListeners();
  }

  PostCommentEndDrawerType endDrawerOpenInfo = PostCommentEndDrawerType.close;
  bool test = false;
  Future<void> changeEndDrawerStatus(PostCommentEndDrawerType status, PostModel choicedPost) async {
    endDrawerOpenInfo = status;
    viewChoicedPost = choicedPost;
    notifyListeners();
    if (status == PostCommentEndDrawerType.open) {
      await Future.delayed(const Duration(milliseconds: 305));
      test = true;
    } else {
      test = false;
    }
    notifyListeners();
  }
}
