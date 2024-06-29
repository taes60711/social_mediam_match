import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/endDrawers/custom_end_drawer.dart';

import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_comment_page.dart';

class NoPostData extends StatelessWidget {
  const NoPostData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.safeHeight,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.commentSlash,
              size: 50,
              color: hintTextColor,
            ),
            const SizedBox(height: 10),
            Text(
              "沒有文章",
              style: TextStyle(
                fontSize: 20,
                color: normalBgColor2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostOption {
  IconData icon;
  String funcText;
  Function buttonFunc;
  PostOption({required this.icon, required this.buttonFunc, required this.funcText});
}

class PostBody extends StatelessWidget {
  final PostModel postData;
  final PostProvider postProvider;
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  final List<PostOption>? bottomSheetFuncs;
  const PostBody({
    super.key,
    required this.postData,
    required this.postProvider,
    required this.globalKey,
    required this.userData,
    required this.gotoFriendPage,
    this.bottomSheetFuncs,
  });

  @override
  Widget build(BuildContext context) {
    // Future<void> opneCommentPage({required PostModel choicedPostData, required Function changeChoicedPostGoodCount}) {
    //   return showDialog(
    //     context: context,
    //     useSafeArea: false,
    //     barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
    //     builder: (BuildContext context) {
    //       return CustomEndDrawer(
    //         child: Dismissible(
    //           direction: DismissDirection.startToEnd,
    //           resizeDuration: const Duration(milliseconds: 1),
    //           onDismissed: (_) => Navigator.of(context).pop(),
    //           key: const Key('key'),
    //           child: PostComment(
    //             choicedPostData: choicedPostData,
    //             userData: userData,
    //             globalKey: globalKey,
    //             gotoFriendPage: gotoFriendPage,
    //             changeChoicedPostGoodCount: changeChoicedPostGoodCount,
    //             postProvider: postProvider,
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    iconWithText(IconData icon, Color iconColor, String text) {
      return Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: hintTextColor),
            ),
          ),
        ],
      );
    }

    Widget breakLine = Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2);

    Color titleBackGroundColor = const Color.fromARGB(255, 236, 157, 120);

    Widget postedUserInfo = Container(
      padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: titleBackGroundColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: UserIcon(iconSize: 35, image: postData.postUserInfo.image),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postData.postUserInfo.name != "" ? postData.postUserInfo.name ?? "" : postData.postUserInfo.email,
                  style: TextStyle(fontSize: 12, color: normalTextColor),
                ),
                Text(
                  "看板: ${postData.type}",
                  style: TextStyle(fontSize: 12, color: normalTextColor),
                )
              ],
            ),
          ),
          Text(
            " ${postData.postTime}前",
            style: TextStyle(
              fontSize: 12,
              color: normalTextColor,
            ),
          ),
        ],
      ),
    );

    Widget postTitle = Text(
      postData.title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );

    Widget postEvaluate = Row(
      children: [
        Expanded(
          child: Row(
            children: [
              iconWithText(FontAwesomeIcons.eye, const Color.fromARGB(255, 63, 63, 63), "${postData.viewed}"),
              iconWithText(FontAwesomeIcons.heart, const Color.fromARGB(255, 248, 110, 110), "${postData.good}"),
              iconWithText(FontAwesomeIcons.comment, Colors.blueAccent, "${postData.commentCount}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.ellipsis,
                color: hintTextColor,
                size: 14,
              ),
            ),
            onTap: () {
              print("Icon");
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (builder) {
                    return DraggableScrollableSheet(
                        expand: false,
                        minChildSize: 0.25,
                        initialChildSize: 0.3,
                        maxChildSize: 0.3,
                        builder: (context, scrollController) {
                          List<PostOption> bSheetFuncs = bottomSheetFuncs ?? [];
                          return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: ScreenSize.width * 0.33,
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        width: ScreenSize.width * 0.33,
                                        child: Icon(
                                          Icons.remove,
                                          size: 35,
                                          color: normalBgColor2,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        padding: const EdgeInsets.only(right: 10),
                                        width: ScreenSize.width * 0.33,
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: ClampingScrollPhysics(),
                                      child: Column(
                                        children: bSheetFuncs
                                            .map((e) => Padding(
                                                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      e.buttonFunc();
                                                    },
                                                    child: Container(
                                                      width: ScreenSize.width,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          color: normalBgColor2, borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 100,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                e.icon,
                                                                color: normalTextColor,
                                                                size: 25,
                                                              ),
                                                              const SizedBox(width: 5),
                                                              SizedBox(
                                                                width: 70,
                                                                child: Center(
                                                                  child: Text(
                                                                    e.funcText,
                                                                    style: TextStyle(color: normalTextColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        });
                  });
            },
          ),
        ),
      ],
    );

    return Container();
  }
}
