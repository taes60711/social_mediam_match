import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'package:social_mediam_match/provider/post/post_comment_provider.dart';
import 'package:social_mediam_match/services/post_service.dart';
import '../../../enum/post_comment_end_drawer_type.dart';
import '../../../enum/user_detail_end_drawer_type.dart';
import '../../../models/user_model.dart';

import '../../../provider/account/user_provider.dart';
import '../../../provider/friend_provider.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';

import '../../../states/post_state.dart';
import '../../user_detail_page.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/custom_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/style_config.dart';
import '../postPage/post_comment_page.dart';

class EditPost extends StatelessWidget {
  final PostState postState;

  const EditPost({super.key, required this.postState});

  @override
  Widget build(BuildContext context) {
    PostModel? choicedPost = postState.choicedPost;
    QuillEditorController controller = QuillEditorController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("編輯"),
            choicedPost != null
                ? Container(
                    width: ScreenSize.width,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () async {
                              print("Drawer Close");

                              postState.myPostsGlobalKey.currentState!.closeEndDrawer();
                            },
                            icon: const Icon(Icons.arrow_back_ios_sharp),
                          ),
                        ),
                        RichTextEditor(controller: controller, content: choicedPost.mainMessage)
                      ],
                    ),
                  )
                : Container(),
            ElevatedButton(
                onPressed: () async {
                  String content = await controller.getText();
                  postState.updatePostData(choicedPost!.id, content);
                  postState.myPostsGlobalKey.currentState!.closeEndDrawer();
                },
                child: const Text("更新"))
          ],
        ),
      ),
    );
  }
}

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    // PostState postState = context.read<PostState>();
    // List<PostModel> myAllPosts = context.watch<PostState>().myAllPosts;
    // GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.myPostsGlobalKey);
    // String myPostEndDrawerType = context.select((PostState value) => value.myPostEndDrawerType);

    // void changeChoicedPostGoodCount({required PostModel choicedPost, required isGood}) {
    //   postState.changeChoicedPostGoodCount(choicedPost: choicedPost, isGood: isGood);
    // }

    // Future<void> deletePostCheck(int postId) {
    //   return showDialog<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('確認'),
    //         content: const Text('確定要刪除該篇文章嗎?'),
    //         actions: <Widget>[
    //           ElevatedButton(
    //             child: const Text('確定'),
    //             onPressed: () {
    //               postState.deletePostData(postId);
    //               Navigator.of(context).pop();
    //               print(postId);
    //             },
    //           ),
    //           ElevatedButton(
    //             child: const Text('取消'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    return Stack(
      children: [
        mainBody(context),
        endDrawer(),
        postCommentEndDrawer(),
      ],
    );
  }

  // return StatefulWrapper(
  //   onInit: () async {
  //     postState.getPostDataByUID(0, 5, userData);
  //   },

  //   child: Scaffold(
  //     key: globalKey,
  //     endDrawer: myPostEndDrawerType == "edit"
  //         ? EditPost(postState: postState)
  //         : PostComment(
  //             choicedPostData: postState.choicedPost ?? PostModel(postUserInfo: LoginUser()),
  //             userData: userData,
  //             globalKey: globalKey,
  //             gotoFriendPage: () => context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom),
  //             changeChoicedPostGoodCount: changeChoicedPostGoodCount,
  //           ),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           BaseTopBar(
  //             backFunc: () => RouteOptions.popUntilToHome(),
  //             title: tr("mypost_title"),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: myAllPosts.length,
  //               itemBuilder: ((context, index) {
  //                 return Column(
  //                   children: [
  //                     PostBody(
  //                       postData: myAllPosts[index],
  //                       postState: postState,
  //                       globalKey: globalKey,
  //                       userData: userData,
  //                       gotoFriendPage: () =>
  //                           context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom),
  //                       bottomSheetFuncs: [
  //                         PostOption(
  //                             icon: Icons.edit,
  //                             buttonFunc: () async {
  //                               RouteOptions.pop();
  //                               await postState.postOnChange(myAllPosts[index], "edit");
  //                               globalKey.currentState!.openEndDrawer();
  //                             },
  //                             funcText: '編輯文章'),
  //                         PostOption(
  //                             icon: FontAwesomeIcons.commentSlash,
  //                             buttonFunc: () {
  //                               RouteOptions.pop();
  //                               deletePostCheck(myAllPosts[index].id);
  //                             },
  //                             funcText: '刪除'),
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //               }),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
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
            child: APIListView<PostModel>(
              providerList: context.watch<BaseAPIListProvider<PostModel>>().posts,
              apiFunc: (page, size) {
                return PostService().getPostDataByUID(page, size, userData);
              },
              itemChild: ((data, index) {
                return Column(
                  children: [
                    /// titlebar
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
                                          const Icon(FontAwesomeIcons.heart, size: 14, color: Color.fromARGB(255, 248, 110, 110)),
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
                                    onTap: () {},
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
