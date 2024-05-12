import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/Stateful_wrapper.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/style_config.dart';
import '../skillExChangePage/user_detail.dart';

class PostComment extends StatelessWidget {
  final PostModel choicedPostData;
  final LoginUser userData;
  final GlobalKey<ScaffoldState> globalKey;
  final VoidCallback gotoFriendPage;
  final Function changeChoicedPostGoodCount;
  final PostState? postState;

  const PostComment({
    super.key,
    required this.choicedPostData,
    required this.userData,
    required this.globalKey,
    required this.gotoFriendPage,
    required this.changeChoicedPostGoodCount,
    this.postState,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> deleteCheck(int uId, PostState postState) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('確定要刪除該篇文章嗎?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('確定'),
                onPressed: () {
                  postState.deletePostComment(uId);
                  Navigator.of(context).pop();
                  print(uId);
                },
              ),
              ElevatedButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return ChangeNotifierProvider(
      create: (_) => PostState(),
      child: Builder(builder: (context) {
        PostState postState = context.read<PostState>();
        List<getPostCommentModel> postCommentData = context.watch<PostState>().postCommentData;

        TextEditingController postCommentInput = context.select((PostState value) => value.postCommentInput);
        bool isPostCommentLoading = context.select((PostState value) => value.isPostCommentLoading);

        bool isGood = context.select((PostState value) => value.isGood);
        GlobalKey<ScaffoldState> globalCommentKey = context.select((PostState value) => value.globalCommentKey);
        LoginUser? otherUser = context.select((PostState value) => value.otherUser);

        print("postCOmment");

        return Scaffold(
          key: globalCommentKey,
          endDrawer: UserDetail(
            globalKey: globalCommentKey,
            userData: userData,
            otherUser: otherUser,
            gotoFriendPage: gotoFriendPage,
          ),
          body: SafeArea(
            child: StatefulWrapper(
              onInit: () async {
                Future.delayed(Duration(milliseconds: 300)).then((value) async =>
                    await postState.getPostCommentData(choicedPostData.id, loginUserUID: userData.uid, searchType: "First"));
              },
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: ScreenSize().width,
                          color: Color.fromARGB(255, 227, 228, 235),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  inspect(choicedPostData.postUserInfo);
                                  if (userData.uid != choicedPostData.postUserInfo.uid) {
                                    postState.openDrawer("userDetail",
                                        globalKey: globalCommentKey, otherUser: choicedPostData.postUserInfo);
                                  }
                                },
                                child: Row(
                                  children: [
                                    UserIcon(
                                      iconSize: 35,
                                      image: choicedPostData.postUserInfo.image,
                                    ),
                                    Text(choicedPostData.postUserInfo.email),
                                  ],
                                ),
                              ),
                              RichTextView(content: choicedPostData.mainMessage),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      isGood
                                          ? await postState.updatePostGood(choicedPostData.id)
                                          : await postState.updatePostGood(choicedPostData.id, userUID: userData.uid);
                                      changeChoicedPostGoodCount(choicedPost: choicedPostData, isGood: isGood);
                                    },
                                    child: isGood ? Text("收回讚") : Text("讚"),
                                  ),
                                  Text(" ${choicedPostData.good} 個讚"),
                                ],
                              ),
                              Text("發文時間 : ${choicedPostData.postTime}"),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8, right: 8),
                                      child: SizedBox(
                                        height: 30,
                                        child: TextField(
                                          controller: postCommentInput,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 5, left: 10),
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter Message',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      postState.createPostComment(choicedPostData.id, postCommentInput.text, userData);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      color: Colors.deepOrange,
                                      child: const Center(
                                        child: Text("傳送訊息"),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: ScreenSize().width,
                    decoration: BoxDecoration(color: normalBgColor2),
                    padding: EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (builder) {
                              return ChangeNotifierProvider(
                                create: (_) => PostState(),
                                child: Builder(builder: (context) {
                                  bool isPostCommentReLoading = context.select((PostState value) => value.isPostCommentReLoading);
                                  bool isPostCommentDataAddLoding =
                                      context.select((PostState value) => value.isPostCommentDataAddLoding);
                                  double startScrollPosition = context.select((PostState value) => value.startScrollPosition);
                                  List<TextEditingController> postCommentMessageController =
                                      context.watch<PostState>().postCommentMessageController;

                                  PostState postState = context.read<PostState>();
                                  return Container(
                                    height: ScreenSize().height * 0.75,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topRight,
                                          margin: const EdgeInsets.only(right: 20, bottom: 5, top: 5),
                                          width: ScreenSize().width,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        isPostCommentReLoading ? Loading() : Container(),
                                        Expanded(
                                          child: NotificationListener<ScrollNotification>(
                                            onNotification: (ScrollNotification scrollNotification) {
                                              if (scrollNotification is ScrollUpdateNotification) {
                                                final scrollPosition = scrollNotification.metrics.pixels;

                                                final max = scrollNotification.metrics.maxScrollExtent;
                                                if (!isPostCommentDataAddLoding && !isPostCommentReLoading) {
                                                  if (scrollPosition > max && !isPostCommentDataAddLoding) {
                                                    postState.postAddData();
                                                  } else if (startScrollPosition <= 0) {
                                                    if (scrollPosition < 0 && !isPostCommentReLoading) {
                                                      postState.postReLoadingPage();
                                                    }
                                                  }
                                                  postState.floatButtonVisiableChange(scrollPosition);
                                                }
                                              }
                                              if (scrollNotification is ScrollEndNotification) {
                                                if (isPostCommentDataAddLoding) {
                                                  postState.getPostCommentData(choicedPostData.id,
                                                      loginUserUID: userData.uid, searchType: "AddData");
                                                } else if (isPostCommentReLoading) {
                                                  postState.getPostCommentData(choicedPostData.id,
                                                      loginUserUID: userData.uid, searchType: "Reload");
                                                }
                                              }
                                              return false;
                                            },
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    physics: BouncingScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        isPostCommentLoading
                                                            ? Loading()
                                                            : Column(
                                                                children: postCommentData.map((e) {
                                                                  return Builder(builder: (context) {
                                                                    int index =
                                                                        postCommentData.indexWhere((element) => element == e);
                                                                    postCommentMessageController[index].text =
                                                                        postCommentData[index].message;
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                                                                      child: Container(
                                                                        padding: EdgeInsets.all(20),
                                                                        color: Colors.grey,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                UserIcon(
                                                                                  iconSize: 40,
                                                                                  image: postCommentData[index]
                                                                                      .commentUserInfo
                                                                                      .image,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(postCommentData[index]
                                                                                          .commentUserInfo
                                                                                          .email),
                                                                                      postCommentData[index].isEditor
                                                                                          ? TextFormField(
                                                                                              controller:
                                                                                                  postCommentMessageController[
                                                                                                      index],
                                                                                              enabled:
                                                                                                  postCommentData[index].isEditor,
                                                                                              style: const TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 14),
                                                                                              decoration: const InputDecoration(
                                                                                                border: OutlineInputBorder(),
                                                                                                isCollapsed: true,
                                                                                                contentPadding:
                                                                                                    EdgeInsets.only(left: 2),
                                                                                                disabledBorder: InputBorder.none,
                                                                                              ),
                                                                                            )
                                                                                          : SelectableText(
                                                                                              postCommentMessageController[index]
                                                                                                  .text)
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: IconButton(
                                                                                    onPressed: () {
                                                                                      deleteCheck(
                                                                                          postCommentData[index].uid, postState);
                                                                                    },
                                                                                    icon: Icon(Icons.close),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      postState.editPostComment(index);
                                                                                    },
                                                                                    child: Text("編輯留言")),
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      postState.changePostComment(
                                                                                          postCommentData[index].uid,
                                                                                          index,
                                                                                          postCommentMessageController[index]
                                                                                              .text);
                                                                                    },
                                                                                    child: Text("更新留言")),
                                                                              ],
                                                                            ),
                                                                            Text(postCommentData[index].postTime),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                                }).toList(),
                                                              ),
                                                        isPostCommentDataAddLoding ? Loading() : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            });
                      },
                      child: Text(
                        "有${choicedPostData.commentCount}則回復",
                        style: TextStyle(color: normalTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
