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

  void changeEndDrawerStatus(PostCommentEndDrawerType status, PostModel choicedPost) {
    endDrawerOpenInfo = status;
    viewChoicedPost = choicedPost;
    notifyListeners();
  }
}
