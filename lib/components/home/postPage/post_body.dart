import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/custom_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_comment.dart';

class PostLoading extends StatelessWidget {
  const PostLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color.fromARGB(255, 214, 214, 214),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(35 / 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 100,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: ScreenSize().width,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 25,
                            height: 11,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoPostData extends StatelessWidget {
  const NoPostData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize().width,
      height: ScreenSize().safeheight,
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

class PostBody extends StatelessWidget {
  final PostModel postData;
  final PostState postState;
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const PostBody({
    super.key,
    required this.postData,
    required this.postState,
    required this.globalKey,
    required this.userData,
    required this.gotoFriendPage,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> opneCommentPage({required PostModel choicedPostData, required Function changeChoicedPostGoodCount}) {
      return showDialog(
        context: context,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
        builder: (BuildContext context) {
          return CustomEndDrawer(
            child: Dismissible(
              direction: DismissDirection.startToEnd,
              resizeDuration: const Duration(milliseconds: 1),
              onDismissed: (_) => Navigator.of(context).pop(),
              key: const Key('key'),
              child: PostComment(
                choicedPostData: choicedPostData,
                userData: userData,
                globalKey: globalKey,
                gotoFriendPage: gotoFriendPage,
                changeChoicedPostGoodCount: changeChoicedPostGoodCount,
              ),
            ),
          );
        },
      );
    }

    void changeChoicedPostGoodCount({required PostModel choicedPost, required isGood}) {
      postState.changeChoicedPostGoodCount(choicedPost: choicedPost, isGood: isGood);
    }

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
            " ${postData.postTime}天前",
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
            child: Icon(
              FontAwesomeIcons.ellipsis,
              color: hintTextColor,
              size: 14,
            ),
            onTap: () {
              print("Icon");
            },
          ),
        ),
      ],
    );

    Widget mainBody = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                inspect(postData.postUserInfo);
                if (userData.uid != postData.postUserInfo.uid) {
                  postState.openDrawer("userDetail", globalKey, otherUser: postData.postUserInfo);
                }
              },
              child: postedUserInfo),
          GestureDetector(
            onTap: () {
              opneCommentPage(
                choicedPostData: postData,
                changeChoicedPostGoodCount: changeChoicedPostGoodCount,
              );
            },
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  postTitle,
                  breakLine,
                  RichTextView(
                    content: postData.mainMessage,
                    isPreView: true,
                  ),
                  breakLine,
                  postEvaluate,
                  breakLine,
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return mainBody;
  }
}
