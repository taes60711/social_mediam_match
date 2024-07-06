import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';

import '../../../models/post_model.dart';
import '../../../provider/post/post_comment_provider.dart';
import '../../home/postPage/post_detail_page.dart';
import 'custom_end_drawer.dart';

enum PostCommentEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create PostCommentProvider

///MARK: void 文章詳細ページ開くように
void openPostDetailEndDrawer({required BuildContext context, required PostModel choicedPost}) {
  context.read<PostCommentProvider>().changeEndDrawerStatus(PostCommentEndDrawerType.open, choicedPost);
}

///MARK: void 文章詳細ページ閉じるように
void closePostDetailEndDrawer({required BuildContext context}) {
  context.read<PostCommentProvider>().changeEndDrawerStatus(PostCommentEndDrawerType.close, PostModel());
}

///MARK: widget 文章詳細ページ用EndDrawer
Widget postDetailEndDrawer() {
  return Builder(builder: (context) {
    print("postCommentEndDrawer");
    PostCommentEndDrawerType postCommentEndDrawer = context.select((PostCommentProvider value) => value.endDrawerOpenInfo);

    Widget endDrawerWidget = Container();

    if (postCommentEndDrawer == PostCommentEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        title: context.read<PostCommentProvider>().viewChoicedPost.title,
        onDismissed: () {
          closePostDetailEndDrawer(context: context);
        },
        loadingBuilder: const PostLoading(),

        ///文章詳細ページ
        child: const PostDetailPage(),
      );
    }
    return endDrawerWidget;
  });
}
