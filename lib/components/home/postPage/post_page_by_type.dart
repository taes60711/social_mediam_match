import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';

import '../../../global.dart';
import '../../../models/post_model.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_page_by_viewer.dart';

class PostPageByType extends StatelessWidget {
  const PostPageByType({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        globalPostContext = context;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Builder(
            builder: (context) {
              int selectedboardType = context.select((PostProvider value) => value.selectedboardIndex);
              return APIListView<PostModel>(
                providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
                apiFunc: (page, size) {
                  return PostService().getPostByType(page, size, selectedboardType);
                },
                loadingBuilder: () {
                  return const PostLoading();
                },
                noDataBuilder: PostViewUtilities.noPostData(),

                ///文章作るボタン
                customFloatbutton: PostViewUtilities.postCreateButton(context),
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
                              "${data[index].postTime}${tr("skExChpage_beforDays")}",
                              style: TextStyle(fontSize: 12, color: normalTextColor),
                            ),
                          ],
                        ),
                      ),

                      ///文章プレビュー
                      GestureDetector(
                        onTap: () {
                          PostViewModel(postContext: context).postDetailInit(choicedPost: data[index]);
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
              );
            },
          ),
        ),
      ),
    );
  }
}
