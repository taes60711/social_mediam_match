import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/custom_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../models/user_model.dart';
import '../skillExChangePage/user_detail.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 218, 219, 219),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostPage extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;

  const PostPage({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    List<PostModel> postData = context.select((PostState value) => value.postData);
    bool isFirstLoading = context.select((PostState value) => value.isFirstLoading);
    bool isDataAddLoding = context.select((PostState value) => value.isDataAddLoding);
    bool isReLoading = context.select((PostState value) => value.isReLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.globalKey);
    LoginUser? otherUser = context.select((PostState value) => value.otherUser);
    bool isCanLoading = context.select((PostState value) => value.isCanLoading);

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

    print("PostPage isFirstLoading: ${isFirstLoading}");

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

    return StatefulWrapper(
      onInit: () async {
        await postState.getPostData(searchType: "First");
      },
      child: isFirstLoading
          ? ShimmerList()
          : Scaffold(
              key: globalKey,
              endDrawer: UserDetail(
                globalKey: globalKey,
                userData: userData,
                otherUser: otherUser,
                gotoFriendPage: gotoFriendPage,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    isReLoading
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Loading(),
                          )
                        : Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollNotification) {
                            if (scrollNotification is ScrollUpdateNotification) {
                              final scrollPosition = scrollNotification.metrics.pixels;
                              final max = scrollNotification.metrics.maxScrollExtent;

                              if (!isDataAddLoding && !isReLoading) {
                                if (scrollPosition > max && isCanLoading && !isDataAddLoding) {
                                  postState.canLoadingChange(false);
                                  postState.addData();
                                } else if (scrollPosition < 0 && isCanLoading && !isReLoading) {
                                  postState.canLoadingChange(false);
                                  postState.reLoadingPage();
                                }
                              }
                              if (!isCanLoading) {
                                if (scrollNotification.dragDetails == null) {
                                  postState.canLoadingChange(true);
                                }
                              }
                            } else if (scrollNotification is ScrollEndNotification) {
                              if (isDataAddLoding && isCanLoading) {
                                postState.getPostData(searchType: "AddData");
                              } else if (isReLoading && isCanLoading) {
                                postState.getPostData(searchType: "Reload");
                              }
                            }

                            return false;
                          },
                          child: ListView.builder(
                            itemCount: postData.length,
                            itemBuilder: (context, index) {
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
                                      child: UserIcon(iconSize: 35, image: postData[index].postUserInfo.image),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            postData[index].postUserInfo.name != ""
                                                ? postData[index].postUserInfo.name ?? ""
                                                : postData[index].postUserInfo.email,
                                            style: TextStyle(fontSize: 12, color: normalTextColor),
                                          ),
                                          Text(
                                            "看板: ${postData[index].type}",
                                            style: TextStyle(fontSize: 12, color: normalTextColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      " ${postData[index].postTime}天前",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: normalTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              Widget postTitle = Text(
                                postData[index].title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              );

                              Widget postEvaluate = Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        iconWithText(FontAwesomeIcons.eye, const Color.fromARGB(255, 63, 63, 63),
                                            "${postData[index].viewed}"),
                                        iconWithText(FontAwesomeIcons.heart, const Color.fromARGB(255, 248, 110, 110),
                                            "${postData[index].good}"),
                                        iconWithText(
                                            FontAwesomeIcons.comment, Colors.blueAccent, "${postData[index].commentCount}"),
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
                                          inspect(postData[index].postUserInfo);
                                          if (userData.uid != postData[index].postUserInfo.uid) {
                                            postState.openDrawer("userDetail", globalKey,
                                                otherUser: postData[index].postUserInfo);
                                          }
                                        },
                                        child: postedUserInfo),
                                    GestureDetector(
                                      onTap: () {
                                        opneCommentPage(
                                          choicedPostData: postData[index],
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
                                              content: postData[index].mainMessage,
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
                              return index != postData.length - 1
                                  ? mainBody
                                  : Column(
                                      children: [
                                        mainBody,
                                        isDataAddLoding
                                            ? const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Loading(),
                                              )
                                            : Container()
                                      ],
                                    );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
