import 'package:flutter/material.dart';

import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
import '../../models/post_model.dart';

class PostCommentProvider extends ChangeNotifier {
  PostModel viewChoicedPost = PostModel();

  TextEditingController postCommentInput = TextEditingController();

  void editInputClear() {
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

  void updateCommentCount({required String updatetype}) {
    if (updatetype == "create") {
      viewChoicedPost.commentCount++;
    } else if (updatetype == "delete") {
      viewChoicedPost.commentCount--;
    }

    notifyListeners();
  }

  PostCommentEndDrawerType endDrawerOpenInfo = PostCommentEndDrawerType.close;
  Future<void> changeEndDrawerStatus(PostCommentEndDrawerType status, PostModel choicedPost) async {
    endDrawerOpenInfo = status;
    viewChoicedPost = choicedPost;
    notifyListeners();
  }
}
