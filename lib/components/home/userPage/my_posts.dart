import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'package:social_mediam_match/provider/post/my_post_view_model.dart';
import 'package:social_mediam_match/provider/post/post_comment_provider.dart';
import 'package:social_mediam_match/services/post_service.dart';
import '../../../enum/post_comment_end_drawer_type.dart';
import '../../../enum/user_detail_end_drawer_type.dart';
import '../../../models/user_model.dart';

import '../../../provider/account/user_provider.dart';
import '../../../provider/friend_provider.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../user_detail_page.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/custom_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/style_config.dart';
import '../postPage/post_comment_page.dart';

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mainBody(context),
        endDrawer(),
        postCommentEndDrawer(),
      ],
    );
  }
}

Widget mainBody(BuildContext context) {
  LoginUser userData = context.watch<UserProvider>().userData;
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          BaseTopBar(
            backFunc: () => RouteOptions.popUntilToHome(),
            title: tr("mypost_title"),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                return APIListView<PostModel>(
                  providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
                  apiFunc: (page, size) {
                    return PostService().getPostDataByUID(page, size, userData);
                  },
                  itemChild: ((data, index) {
                    return Column(
                      children: [
                        /// 文章TOPbar
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
                                  GestureDetector(
                                    onTap: () {
                                      context.read<FriendProvider>().changeEndDrawerStatus(
                                            UserDetailEndDrawerType.open,
                                            data[index].postUserInfo,
                                          );
                                    },
                                    child: UserIcon(
                                      iconSize: 35,
                                      image: data[index].postUserInfo.image,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data[index].postUserInfo.name != ""
                                        ? data[index].postUserInfo.name ?? ""
                                        : data[index].postUserInfo.email,
                                    style: TextStyle(fontSize: 12, color: normalTextColor),
                                  ),
                                ],
                              ),
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
                            context.read<PostCommentProvider>().changeEndDrawerStatus(PostCommentEndDrawerType.open, data[index]);
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
                                RichTextView(
                                  content: data[index].mainMessage,
                                  isPreView: true,
                                ),
                                Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(FontAwesomeIcons.eye, size: 14, color: Color.fromARGB(255, 63, 63, 63)),
                                              const SizedBox(width: 5),
                                              Text("${data[index].viewed}"),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              const Icon(FontAwesomeIcons.heart,
                                                  size: 14, color: Color.fromARGB(255, 248, 110, 110)),
                                              const SizedBox(width: 5),
                                              Text("${data[index].good}"),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              const Icon(FontAwesomeIcons.comment, size: 14, color: Colors.blueAccent),
                                              const SizedBox(width: 5),
                                              Text("${data[index].commentCount}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          MyPostViewModel(myPostContext: context).showOptionBottomSheet(choicedPost: data[index]);
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
                                ),
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
        ],
      ),
    ),
  );
}

///　ユーザ詳細ページ用EndDrawer
Widget endDrawer() {
  return Builder(
    builder: (context) {
      print("customEndDrawer");
      UserDetailEndDrawerType endDrawer = context.select((FriendProvider value) => value.endDrawerOpenInfo);

      FriendProvider friendProivder = context.read<FriendProvider>();

      Widget endDrawerWidget = Container();

      if (endDrawer == UserDetailEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            friendProivder.changeEndDrawerStatus(UserDetailEndDrawerType.close, LoginUser());
          },
          child: UserDetailPage(
            otherUser: context.read<FriendProvider>().ohterUserData,
            toChatRoom: () {
              context.read<FriendProvider>().changeEndDrawerStatus(UserDetailEndDrawerType.close, LoginUser());
            },
          ),
        );
      }

      return endDrawerWidget;
    },
  );
}

/// 文章詳細ページ用EndDrawer
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
          postCommentProvider.changeEndDrawerStatus(
            PostCommentEndDrawerType.close,
            PostModel(),
          );
        },
        child: const PostCommentPage(),
      );
    }
    return endDrawerWidget;
  });
}
