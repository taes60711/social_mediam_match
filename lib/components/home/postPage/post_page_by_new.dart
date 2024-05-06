import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../models/user_model.dart';

import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../skillExChangePage/user_detail.dart';

class LeftToRightAnimationDialog extends StatefulWidget {
  final Widget child;

  LeftToRightAnimationDialog({required this.child});

  @override
  _LeftToRightAnimationDialogState createState() => _LeftToRightAnimationDialogState();
}

class _LeftToRightAnimationDialogState extends State<LeftToRightAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class PostPageByNew extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;

  const PostPageByNew({super.key, required this.userData, required this.gotoFriendPage});

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

    Future<void> tts({required PostModel choicedPostData, required Function changeChoicedPostGoodCount}) {
      return showDialog(
        context: context,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
        builder: (BuildContext context) {
          return LeftToRightAnimationDialog(
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

    print("NewsPostPage isFirstLoading: ${isFirstLoading}");
    return StatefulWrapper(
      onInit: () async {
        await postState.getNewsPostData(searchType: "First");
      },
      child: isFirstLoading
          ? const Loading()
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
                            }
                            if (scrollNotification is ScrollEndNotification) {
                              if (isDataAddLoding && isCanLoading) {
                                postState.getNewsPostData(searchType: "AddData");
                              } else if (isReLoading && isCanLoading) {
                                postState.getNewsPostData(searchType: "Reload");
                              }
                            }
                            return false;
                          },
                          child: postData.isEmpty
                              ? SizedBox(
                                  width: ScreenSize().width,
                                  child: AspectRatio(
                                    aspectRatio: 16.0 / 9.0,
                                    child: BackgroundWidget(
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
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: postData.length,
                                  itemBuilder: (context, index) {
                                    return index != postData.length - 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                            child: GestureDetector(
                                              onTap: () async {
                                                tts(
                                                  choicedPostData: postData[index],
                                                  changeChoicedPostGoodCount: changeChoicedPostGoodCount,
                                                );
                                                await postState.openDrawer("movetoPost", globalKey,
                                                    loginUserData: userData, choicedPostData: postData[index]);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(width: 0.2, color: normalBgColor2),
                                                  ),
                                                ),
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
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color.fromARGB(255, 236, 157, 120),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            UserIcon(
                                                              iconSize: 35,
                                                              image: postData[index].postUserInfo.image,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    postData[index].postUserInfo.email,
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
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            postData[index].title,
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets.symmetric(vertical: 5),
                                                              height: 0.2,
                                                              color: normalBgColor2),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                                            child: RichTextView(
                                                              content: postData[index].mainMessage,
                                                              isPreView: true,
                                                            ),
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets.symmetric(vertical: 5),
                                                              height: 0.2,
                                                              color: normalBgColor2),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      FontAwesomeIcons.eye,
                                                                      size: 14,
                                                                      color: Color.fromARGB(255, 63, 63, 63),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Text(
                                                                        "${postData[index].viewed}",
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          color: hintTextColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      FontAwesomeIcons.heart,
                                                                      size: 14,
                                                                      color: Color.fromARGB(255, 248, 110, 110),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Text(
                                                                        "${postData[index].good}",
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          color: hintTextColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Icon(FontAwesomeIcons.comment,
                                                                        size: 14, color: Colors.blueAccent),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Text(
                                                                        "${postData[index].commentCount}",
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          color: hintTextColor,
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    tts(
                                                      choicedPostData: postData[index],
                                                      changeChoicedPostGoodCount: changeChoicedPostGoodCount,
                                                    );
                                                    await postState.openDrawer("movetoPost", globalKey,
                                                        loginUserData: userData, choicedPostData: postData[index]);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(bottom: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(width: 0.2, color: normalBgColor2),
                                                      ),
                                                    ),
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
                                                          child: Container(
                                                            padding: EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(3),
                                                              color: Color.fromARGB(255, 236, 157, 120),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                UserIcon(
                                                                  iconSize: 35,
                                                                  image: postData[index].postUserInfo.image,
                                                                ),
                                                                SizedBox(width: 10),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        postData[index].postUserInfo.email,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                postData[index].title,
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.symmetric(vertical: 5),
                                                                  height: 0.2,
                                                                  color: normalBgColor2),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                child: RichTextView(
                                                                  content: postData[index].mainMessage,
                                                                  isPreView: true,
                                                                ),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.symmetric(vertical: 5),
                                                                  height: 0.2,
                                                                  color: normalBgColor2),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesomeIcons.eye,
                                                                          size: 14,
                                                                          color: Color.fromARGB(255, 63, 63, 63),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child: Text(
                                                                            "${postData[index].viewed}",
                                                                            style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: hintTextColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                          FontAwesomeIcons.heart,
                                                                          size: 14,
                                                                          color: Color.fromARGB(255, 248, 110, 110),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child: Text(
                                                                            "${postData[index].good}",
                                                                            style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: hintTextColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Icon(FontAwesomeIcons.comment,
                                                                            size: 14, color: Colors.blueAccent),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child: Text(
                                                                            "${postData[index].commentCount}",
                                                                            style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: hintTextColor,
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
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
