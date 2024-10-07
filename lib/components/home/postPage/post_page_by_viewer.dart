import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../global.dart';
import '../../../models/post_model.dart';
import '../../../pagemanager/enum/route_path.dart';
import '../../../pagemanager/setting/route_controller.dart';
import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/Stateful_wrapper.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class PostPageByViewer extends StatelessWidget {
  const PostPageByViewer({super.key});

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
              return APIListView<PostModel>(
                providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
                apiFunc: (page, size) {
                  return PostService().getPostDataByViewer(page, size);
                },
                customFloatbutton: GestureDetector(
                  onTap: () {
                    /// 文章作成

                    RouteOptions.pushTo(
                      RoutePath.postEditPage,
                      arguments: {
                        'postContext': context,
                        'allPostBoradTypeList': context.read<PostProvider>().allPostBoards,
                        'editorType': "create",
                      },
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: normalBgColor,
                    ),
                  ),
                ),
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
                loadingBuilder: () {
                  return const PostLoading();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

///文章bottomBar
Widget bottomBar({required BuildContext context, required PostModel data}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ///リーチ数
            Row(
              children: [
                const Icon(FontAwesomeIcons.eye, size: 14, color: Color.fromARGB(255, 63, 63, 63)),
                const SizedBox(width: 5),
                Text("${data.viewed}"),
              ],
            ),
            const SizedBox(width: 8),

            ///いいね数
            Row(
              children: [
                const Icon(FontAwesomeIcons.heart, size: 14, color: Color.fromARGB(255, 248, 110, 110)),
                const SizedBox(width: 5),
                Text("${data.good}"),
              ],
            ),
            const SizedBox(width: 8),

            ///コメント数
            Row(
              children: [
                const Icon(FontAwesomeIcons.comment, size: 14, color: Colors.blueAccent),
                const SizedBox(width: 5),
                Text("${data.commentCount}"),
              ],
            ),
          ],
        ),

        ///設定ボタン
        GestureDetector(
          onTap: () {
            context.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: data);
            PostViewModel(postContext: context).showOptionBottomSheet(choicedPost: data);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.transparent,
            child: Icon(
              FontAwesomeIcons.ellipsis,
              color: hintTextColor,
              size: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
