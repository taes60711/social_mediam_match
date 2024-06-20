import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';

class PostsProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  Future<void> getPostDataByUID(int page, int size, LoginUser userData) async {
    try {
      List<PostModel> tempPostsData = [];
      tempPostsData = await PostService().getPostDataByUID(page, size, userData);
      posts = tempPostsData;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
