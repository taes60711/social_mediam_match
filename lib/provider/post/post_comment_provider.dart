import 'package:flutter/material.dart';

import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
import '../../models/post_model.dart';

class PostCommentProvider extends ChangeNotifier {
  PostModel viewChoicedPost = PostModel();
  PostCommentEndDrawerType endDrawerOpenInfo = PostCommentEndDrawerType.close;

  void changeEndDrawerStatus(PostCommentEndDrawerType status, PostModel choicedPost) {
    endDrawerOpenInfo = status;
    viewChoicedPost = choicedPost;
    notifyListeners();
  }
}
