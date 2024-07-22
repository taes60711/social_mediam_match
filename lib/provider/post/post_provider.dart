import 'package:flutter/material.dart';

import '../../components/utilities/endDrawers/post_board_end_drawer.dart';
import '../../components/utilities/endDrawers/post_page_by_text_filter_end_drawer.dart';
import '../../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  TextEditingController textFilterInput = TextEditingController();

  List<PostBoard> allPostBoards = [];
  void getAllPostBoard(List<PostBoard> postBoard) {
    allPostBoards = [...allPostBoards, ...postBoard];
    notifyListeners();
  }

  List<PostModel> topPost = [];
  void getTopPost(List<PostModel> requestPostData) {
    topPost = [...topPost, ...requestPostData];
    notifyListeners();
  }

  bool isGood = false;
  void changeIsGoodStatus(bool changedGood) {
    isGood = changedGood;
    notifyListeners();
  }

  PostBoardEndDrawerType endDrawerOpenInfo = PostBoardEndDrawerType.close;
  int selectedboardIndex = 0;
  void changeEndDrawerStatus(PostBoardEndDrawerType status, int boardType) {
    endDrawerOpenInfo = status;
    selectedboardIndex = boardType;
    notifyListeners();
  }

  PostPageBytextFilterEndDrawerType postPageBytextFilterEndDrawerOpenInfo = PostPageBytextFilterEndDrawerType.close;
  void changePostPageBytextFilterEndDrawerStatus(PostPageBytextFilterEndDrawerType status) {
    postPageBytextFilterEndDrawerOpenInfo = status;
    notifyListeners();
  }
}
