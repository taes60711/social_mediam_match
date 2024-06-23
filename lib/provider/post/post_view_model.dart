import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../models/rich_text_format.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';

class PostViewModel {
  BuildContext postContext;
  PostViewModel({required this.postContext});

  Future<void> createPost({required String title, required String msg, required int type}) async {
    LoginUser userData = postContext.read<UserProvider>().userData;
    String fomattedContent = await RichTextFormat(htmlString: msg).sendPostImgFormat();
    // postContext.read<BaseAPIListProvider<PostModel>>().createData(createdData: createdData);
    await PostService().createPost(userData.uid, title, fomattedContent, type);
  }
}
