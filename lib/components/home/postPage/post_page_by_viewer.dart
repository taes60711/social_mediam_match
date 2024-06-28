import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/post_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/post_comment_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import '../userPage/my_posts.dart';
import 'post_body.dart';

class PostPageByViewer extends StatelessWidget {
  const PostPageByViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return APIListView<PostModel>(
            providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
            apiFunc: (page, size) {
              return PostService().getPostDataByViewer(page, size);
            },
            itemChild: ((data, index) {
              return Column(
                children: [
                  /// 文章TopBar
                  Container(
                    width: ScreenSize.width,
                    padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: const Color.fromARGB(255, 236, 157, 120),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ///アイコン
                            GestureDetector(
                              onTap: () {
                                openUserDetailEndDrawer(context: context, otherUserData: data[index].postUserInfo);
                              },
                              child: UserIcon(
                                iconSize: 35,
                                image: data[index].postUserInfo.image,
                              ),
                            ),
                            const SizedBox(width: 10),

                            ///ユーザネーム
                            Text(
                              data[index].postUserInfo.name != ""
                                  ? data[index].postUserInfo.name ?? ""
                                  : data[index].postUserInfo.email,
                              style: TextStyle(fontSize: 12, color: normalTextColor),
                            ),
                          ],
                        ),

                        ///期日
                        Text(
                          "${data[index].postTime}前",
                          style: TextStyle(fontSize: 12, color: normalTextColor),
                        ),
                      ],
                    ),
                  ),

                  ///文章プレビュー
                  GestureDetector(
                    onTap: () {
                      openPostCommentEndDrawer(context: context, choicedPost: data[index]);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Title
                          Text(
                            data[index].title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),

                          /// 文章プレビュー
                          RichTextView(
                            content: data[index].mainMessage,
                            isPreView: true,
                          ),

                          Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),

                          ///文章bottomBar
                          bottomBar(context: context, data: data[index]),

                          Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            loadingBuilder: () {
              return const PostLoading();
            },
          );
        },
      ),
    );
  }
}
