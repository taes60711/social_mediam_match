import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';

import '../../../models/post_model.dart';
import '../../home/postPage/post_page_by_type.dart';
import '../apiListView/base_api_list_provider.dart';
import 'custom_end_drawer.dart';

enum PostBoardEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create PostProvider

///MARK: void 文章Forumページ開くように
void openPostBoardEndDrawer({required BuildContext context, required int boardType}) {
  context.read<PostProvider>().changeEndDrawerStatus(PostBoardEndDrawerType.open, boardType);
}

///MARK: void 文章Forumページ閉じるように
void closePostBoardEndDrawer({required BuildContext context}) {
  context.read<PostProvider>().changeEndDrawerStatus(PostBoardEndDrawerType.close, -1);
}

///MARK: widget 文章Forumページ用EndDrawer
Widget postBoardEndDrawer() {
  return Builder(builder: (context) {
    print("postBoardEndDrawer");
    PostBoardEndDrawerType postBoardEndDrawer = context.select((PostProvider value) => value.endDrawerOpenInfo);

    Widget endDrawerWidget = Container();

    if (postBoardEndDrawer == PostBoardEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        onDismissed: () {
          closePostBoardEndDrawer(context: context);
        },

        ///文章詳細ページ
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
          ],
          child: const PostPageByType(),
        ),
      );
    }
    return endDrawerWidget;
  });
}
