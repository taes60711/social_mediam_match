import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../global.dart';
import '../../../models/post_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/Stateful_wrapper.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';

import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_utilities.dart';

class PostPageByViewer extends StatelessWidget {
  const PostPageByViewer({super.key});

  @override
  Widget build(BuildContext context) {
    List<PostBoard> allPostBoards = context.select((PostProvider value) => value.allPostBoards);
    return StatefulWrapper(
      onInit: () {
        globalPostContext = context;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Builder(
            builder: (context) {
              return APIListView<PostModel>(
                providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
                apiFunc: (page, size) {
                  return PostService().getPostDataByViewer(page, size);
                },

                ///文章作るボタン
                customFloatbutton: PostViewUtilities.postCreateButton(context),
                itemChild: ((data, index) {
                  return GestureDetector(
                    onLongPress: () {
                      context.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: data[index]);
                      PostViewModel(postContext: context).showOptionBottomSheet(choicedPost: data[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3),
                                    child: Text(
                                      data[index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  /// 文章プレビュー
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: RichTextView(
                                      content: data[index].mainMessage,
                                      isPreView: true,
                                    ),
                                  ),

                                  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                      height: 0.2,
                                      color: normalBgColor2),

                                  ///文章bottomBar
                                  bottomBar(context: context, data: data[index]),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                color: Colors.black38,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                PostViewModel(postContext: context).getBoardName(allPostBoards, data[index]),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: PostViewUtilities().iconWithText(
                                            iconData: FontAwesomeIcons.eye,
                                            text: "${data[index].viewed}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            openUserDetailEndDrawer(context: context, otherUserData: data.postUserInfo);
          },
          child: UserIcon(
            iconSize: 28,
            image: data.postUserInfo.image,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              ///いいね数
              PostViewUtilities().iconWithText(
                iconData: FontAwesomeIcons.heart,
                iconColor: const Color.fromARGB(255, 248, 110, 110),
                text: "${data.good}",
              ),

              const SizedBox(width: 8),

              ///コメント数
              PostViewUtilities().iconWithText(
                iconData: FontAwesomeIcons.comment,
                iconColor: Colors.blueAccent,
                text: "${data.commentCount}",
              ),
              const SizedBox(width: 13),

              ///設定ボタン
              GestureDetector(
                onTap: () {
                  context.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: data);
                  PostViewModel(postContext: context).showOptionBottomSheet(choicedPost: data);
                },
                child: Container(
                  width: 30,
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  child: const Icon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: Colors.black87,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        ///期日
        Text(
          "${data.postTime}${tr("skExChpage_beforDays")}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  );
}
