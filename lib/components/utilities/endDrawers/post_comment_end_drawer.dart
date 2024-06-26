import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enum/post_comment_end_drawer_type.dart';
import '../../../models/post_model.dart';
import '../../../provider/post/post_comment_provider.dart';
import '../../home/postPage/post_comment_page.dart';
import 'custom_end_drawer.dart';

///Before use need ParentWidget Create PostCommentProvider

///MARK: void 文章詳細ページ開くように
void openPostCommentEndDrawer({required BuildContext context, required PostModel choicedPost}) {
  context.read<PostCommentProvider>().changeEndDrawerStatus(PostCommentEndDrawerType.open, choicedPost);
}

///MARK: widget 文章詳細ページ用EndDrawer
Widget postCommentEndDrawer() {
  return Builder(builder: (context) {
    print("postCommentEndDrawer");
    PostCommentEndDrawerType postCommentEndDrawer = context.select((PostCommentProvider value) => value.endDrawerOpenInfo);

    PostCommentProvider postCommentProvider = context.read<PostCommentProvider>();

    Widget endDrawerWidget = Container();

    if (postCommentEndDrawer == PostCommentEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        title: context.read<PostCommentProvider>().viewChoicedPost.title,
        onDismissed: () {
          postCommentProvider.changeEndDrawerStatus(PostCommentEndDrawerType.close, PostModel());
        },

        ///文章詳細ページ
        child: const PostCommentPage(),
      );
    }
    return endDrawerWidget;
  });
}
