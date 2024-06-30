import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';

import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
import '../../models/post_model.dart';
import '../../models/rich_text_format.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';
import 'post_comment_provider.dart';

class PostViewModel {
  BuildContext postContext;
  PostViewModel({required this.postContext});

  Future<void> createPost({required String title, required String msg, required int type}) async {
    LoginUser userData = postContext.read<UserProvider>().userData;
    String fomattedContent = await RichTextFormat(htmlString: msg).sendPostImgFormat();
    // postContext.read<BaseAPIListProvider<PostModel>>().createData(createdData: createdData);
    await PostService().createPost(userData.uid, title, fomattedContent, type);
  }

  Future<void> postDetailInit({required PostModel choicedPost}) async {
    openPostDetailEndDrawer(context: postContext, choicedPost: choicedPost);
    LoginUser userData = postContext.read<UserProvider>().userData;
    bool isGood = await PostService().checkIsPostGood(postId: choicedPost.id, userUID: userData.uid);
    postContext.read<PostProvider>().changeIsGoodStatus(isGood);

    if (choicedPost.createdBy != userData.uid) {
      await PostService().updatePostViewCount(choicedPost.id);
    }
  }

  Future<void> updatePostGood({required bool isGood, required PostModel viewChoicedPost}) async {
    LoginUser userData = postContext.read<UserProvider>().userData;
    if (isGood) {
      await PostService().updatePostGood(viewChoicedPost.id);

      postContext.read<PostCommentProvider>().updateChoicedPostGoodCount(isPlus: false);
    } else {
      await PostService().updatePostGood(viewChoicedPost.id, userUID: userData.uid);
      postContext.read<PostCommentProvider>().updateChoicedPostGoodCount(isPlus: true);
    }
    postContext.read<PostProvider>().changeIsGoodStatus(!isGood);
  }

  void showPostCommentPageSheet({required PostModel choicedPost}) {
    showModalBottomSheet(
        context: postContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostCommentTextEditorModel>()),
            ],
            child: DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.55,
              initialChildSize: 0.6,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: PostCommentPage(choicedPost: choicedPost),
                );
              },
            ),
          );
        });
  }
}
