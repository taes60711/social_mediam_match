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

class PostComment extends StatelessWidget {
  final PostModel choicedPostData;
  final LoginUser userData;
  final GlobalKey<ScaffoldState> globalKey;
  const PostComment({
    super.key,
    required this.choicedPostData,
    required this.userData,
    required this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> exitCheck(int uId, PostState postState) {
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
        List<PostCommentModel> postCommentData = context.watch<PostState>().postCommentData;
        TextEditingController postCommentInput = context.select((PostState value) => value.postCommentInput);
        bool isPostCommentLoading = context.select((PostState value) => value.isPostCommentLoading);

        Widget commentComponent;
        if (isPostCommentLoading) {
          commentComponent = const Loading();
        } else {
          commentComponent = Expanded(
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        final before = scrollNotification.metrics.extentBefore;
                        final max = scrollNotification.metrics.maxScrollExtent;
                        if (before == max) {
                          postState.getPostCommentData(choicedPostData.id, isFirstSearch: false);
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: postCommentData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
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
                                      image: postCommentData[index].commentUserInfo.image,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(postCommentData[index].commentUserInfo.email),
                                          Text(postCommentData[index].message),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            print(postCommentData[index].uid);
                                            exitCheck(postCommentData[index].uid ?? -1, postState);
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ),
                                    ),
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
          body: SafeArea(
            child: StatefulWrapper(
              onInit: () async {
                await postState.getPostCommentData(choicedPostData.id, isFirstSearch: true);
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
