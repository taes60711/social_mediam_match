import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';

import '../../utilities/rich_text_view.dart';
import '../skillExChangePage/user_detail.dart';

class RightToLeftAnimationDialog extends StatefulWidget {
  final Widget child;

  RightToLeftAnimationDialog({required this.child});

  @override
  _RightToLeftAnimationDialogState createState() => _RightToLeftAnimationDialogState();
}

class _RightToLeftAnimationDialogState extends State<RightToLeftAnimationDialog> with SingleTickerProviderStateMixin {
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

class PostPageByType extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  final int type;

  const PostPageByType({super.key, required this.type, required this.userData, required this.gotoFriendPage});

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
          return RightToLeftAnimationDialog(
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
        await postState.getPostDataByType(type, searchType: "First");
      },
      child: isFirstLoading
          ? Scaffold(
              body: const Loading(),
            )
          : Scaffold(
              key: globalKey,
              endDrawer: UserDetail(
                globalKey: globalKey,
                userData: userData,
                otherUser: otherUser,
                gotoFriendPage: gotoFriendPage,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RoutePath.postEditPage.value, arguments: {
                    "userData": userData,
                    "postState": postState,
                    "type": type,
                  });
                },
                child: Icon(Icons.edit),
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
                                postState.getPostDataByType(type, searchType: "AddData");
                              } else if (isReLoading && isCanLoading) {
                                postState.getPostDataByType(type, searchType: "Reload");
                              }
                            }
                            return false;
                          },
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
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
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color.fromARGB(255, 218, 219, 219),
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
                                                child: Row(
                                                  children: [
                                                    UserIcon(
                                                      iconSize: 50,
                                                      image: postData[index].postUserInfo.image,
                                                    ),
                                                    Text(postData[index].postUserInfo.email),
                                                  ],
                                                ),
                                              ),
                                              RichTextView(
                                                content: postData[index].mainMessage.length >= 100
                                                    ? postData[index].mainMessage.substring(0, 100)
                                                    : postData[index].mainMessage,
                                              ),
                                              Row(
                                                children: [
                                                  Text("已 ${postData[index].viewed} 人瀏覽過"),
                                                  Text(" ${postData[index].good} 個讚"),
                                                ],
                                              ),
                                              Text("發文時間 : ${postData[index].postTime}"),
                                              Text("有${postData[index].commentCount}則留言"),
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
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: const Color.fromARGB(255, 218, 219, 219),
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
                                                    child: Row(
                                                      children: [
                                                        UserIcon(
                                                          iconSize: 50,
                                                          image: postData[index].postUserInfo.image,
                                                        ),
                                                        Text(postData[index].postUserInfo.email),
                                                      ],
                                                    ),
                                                  ),
                                                  RichTextView(
                                                    content: postData[index].mainMessage.length >= 100
                                                        ? postData[index].mainMessage.substring(0, 100)
                                                        : postData[index].mainMessage,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("已 ${postData[index].viewed} 人瀏覽過"),
                                                      Text(" ${postData[index].good} 個讚"),
                                                    ],
                                                  ),
                                                  Text("發文時間 : ${postData[index].postTime}"),
                                                  Text("有${postData[index].commentCount}則留言"),
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
