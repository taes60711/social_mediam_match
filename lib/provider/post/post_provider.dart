import 'package:flutter/material.dart';

import '../../components/utilities/endDrawers/post_board_end_drawer.dart';
import '../../components/utilities/endDrawers/post_page_by_text_filter_end_drawer.dart';

class PostProvider extends ChangeNotifier {
  bool isGood = false;

  TextEditingController messageInput = TextEditingController();
  TextEditingController textFilterInput = TextEditingController();

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
