import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/Stateful_wrapper.dart';
import '../skillExChangePage/user_detail.dart';

class PostComment extends StatelessWidget {
  final PostModel choicedPostData;
  final LoginUser userData;
  final GlobalKey<ScaffoldState> globalKey;
  final VoidCallback gotoFriendPage;
  final Function changeChoicedPostGoodCount;

  const PostComment({
    super.key,
    required this.choicedPostData,
    required this.userData,
    required this.globalKey,
    required this.gotoFriendPage,
    required this.changeChoicedPostGoodCount,
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
        List<TextEditingController> postCommentMessageController = context.watch<PostState>().postCommentMessageController;
        TextEditingController postCommentInput = context.select((PostState value) => value.postCommentInput);
        bool isPostCommentLoading = context.select((PostState value) => value.isPostCommentLoading);
        bool isPostCommentDataAddLoding = context.select((PostState value) => value.isPostCommentDataAddLoding);
        bool isPostCommentReLoading = context.select((PostState value) => value.isPostCommentReLoading);
        bool isGood = context.select((PostState value) => value.isGood);
        GlobalKey<ScaffoldState> globalCommentKey = context.select((PostState value) => value.globalCommentKey);
        LoginUser? otherUser = context.select((PostState value) => value.otherUser);

        print("postCOmment");
        Widget commentComponent;
        if (isPostCommentLoading) {
          commentComponent = const Loading();
        } else {
          commentComponent = Expanded(
            child: Column(
              children: [
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
                          } else if (scrollPosition < 0 && !isPostCommentReLoading) {
                            postState.postReLoadingPage();
                          }
                        }
                      }
                      if (scrollNotification is ScrollEndNotification) {
                        if (isPostCommentDataAddLoding) {
                          postState.getPostCommentData(choicedPostData.id, loginUserUID: userData.uid, searchType: "AddData");
                        } else if (isPostCommentReLoading) {
                          postState.getPostCommentData(choicedPostData.id, loginUserUID: userData.uid, searchType: "Reload");
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: postCommentData.length,
                      itemBuilder: (context, index) {
                        postCommentMessageController[index].text = postCommentData[index].message;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.grey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    inspect(postCommentData[index].commentUserInfo);
                                    if (userData.uid != postCommentData[index].commentUserInfo.uid) {
                                      postState.openDrawer("userDetail", globalCommentKey,
                                          otherUser: postCommentData[index].commentUserInfo);
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UserIcon(
                                        iconSize: 40,
                                        image: postCommentData[index].commentUserInfo.image,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(postCommentData[index].commentUserInfo.email),
                                            TextFormField(
                                              controller: postCommentMessageController[index],
                                              enabled: postCommentData[index].isEditor,
                                              style: const TextStyle(color: Colors.black, fontSize: 14),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isCollapsed: true,
                                                contentPadding: EdgeInsets.only(left: 2),
                                                disabledBorder: InputBorder.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            deleteCheck(postCommentData[index].uid ?? -1, postState);
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                              postCommentData[index].uid ?? -1, index, postCommentMessageController[index].text);
                                        },
                                        child: Text("更新留言")),
                                  ],
                                ),
                                Text(postCommentData[index].postTime),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                isPostCommentDataAddLoding ? Loading() : Container(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
          );
        }
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
                await postState.getPostCommentData(choicedPostData.id, loginUserUID: userData.uid, searchType: "First");
              },
              onDispose: () {
                PostState().dispose();
              },
              child: SizedBox(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () async {
                          print("Drawer Close");
                          globalKey.currentState!.closeEndDrawer();
                        },
                        icon: const Icon(Icons.arrow_back_ios_sharp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: ScreenSize().width,
                        color: Colors.indigo,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                inspect(choicedPostData.postUserInfo);
                                if (userData.uid != choicedPostData.postUserInfo.uid) {
                                  postState.openDrawer("userDetail", globalCommentKey, otherUser: choicedPostData.postUserInfo);
                                }
                              },
                              child: Row(
                                children: [
                                  UserIcon(
                                    iconSize: 50,
                                    image: choicedPostData.postUserInfo.image,
                                  ),
                                  Text(choicedPostData.postUserInfo.email),
                                ],
                              ),
                            ),
                            Text(choicedPostData.mainMessage),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    isGood
                                        ? postState.updatePostGood(choicedPostData.id)
                                        : postState.updatePostGood(choicedPostData.id, userUID: userData.uid);
                                    changeChoicedPostGoodCount(choicedPost: choicedPostData, isGood: isGood);
                                  },
                                  child: isGood ? Text("收回讚") : Text("讚"),
                                ),
                                Text(" ${choicedPostData.good} 個讚"),
                              ],
                            ),
                            Text("發文時間 : ${choicedPostData.postTime}"),
                          ],
                        ),
                      ),
                    ),
                    commentComponent
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
