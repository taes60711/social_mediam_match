import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/post_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../home/postPage/post_page_by_textfilter.dart';
import '../apiListView/base_api_list_provider.dart';
import 'custom_end_drawer.dart';

enum PostPageBytextFilterEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create PostProvider

///MARK: void 文章Forumページ開くように
void openPostPageBytextFilterEndDrawer({required BuildContext context}) {
  context.read<PostProvider>().changePostPageBytextFilterEndDrawerStatus(PostPageBytextFilterEndDrawerType.open);
}

///MARK: void 文章Forumページ閉じるように
void closePostPageBytextFilterEndDrawer({required BuildContext context}) {
  context.read<PostProvider>().changePostPageBytextFilterEndDrawerStatus(PostPageBytextFilterEndDrawerType.close);
}

///MARK: widget 文章Forumページ用EndDrawer
Widget postPageBytextFilterEndDrawer() {
  return Builder(builder: (context) {
    print("postBoardEndDrawer");
    PostPageBytextFilterEndDrawerType postBoardEndDrawer =
        context.select((PostProvider value) => value.postPageBytextFilterEndDrawerOpenInfo);

    Widget endDrawerWidget = Container();

    if (postBoardEndDrawer == PostPageBytextFilterEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        isNeedTopbar: false,
        onDismissed: () {
          closePostPageBytextFilterEndDrawer(context: context);
        },

        ///文章詳細ページ
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
            ChangeNotifierProvider(create: (_) => PostProvider()),
          ],
          child: PostPageByTextFilter(
            onDismissed: () {
              closePostPageBytextFilterEndDrawer(context: context);
            },
          ),
        ),
      );
    }
    return endDrawerWidget;
  });
}
