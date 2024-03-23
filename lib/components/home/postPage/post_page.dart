import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/style/screen_size.dart';
import '../skillExChangePage/user_detail.dart';

class PostPage extends StatelessWidget {
  final LoginUser? userData;
  final VoidCallback gotoFriendPage;
  const PostPage({super.key, this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    List<PostModel> postData = context.select((PostState value) => value.postData);
    bool isFirstLoading = context.select((PostState value) => value.isFirstLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.globalKey);
    LoginUser? otherUser = context.select((PostState value) => value.otherUser);
    openBottomSheet(int postId) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => PostState(),
            child: Builder(builder: (context) {
              PostState postState = context.read<PostState>();
              List<PostCommentModel> postCommentData = context.watch<PostState>().postCommentData;
              TextEditingController postCommentInput = context.select((PostState value) => value.postCommentInput);
              return StatefulWrapper(
                onInit: () async {
                  await postState.getPostCommentData(postId);
                },
                onDispose: () {
                  PostState().dispose();
                },
                child: SizedBox(
                  height: ScreenSize().height * .65,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        bottom: 0,
                        child: Container(
                          width: ScreenSize().width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: postCommentData.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.greenAccent,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(postCommentData[index].userUid),
                                                      Text(postCommentData[index].message),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(postCommentData[index].postTime),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                userData != null
                                    ? Row(
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
                                              postState.createPostComment(postId, userData!.uid, postCommentInput.text);
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
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      );
    }

    print("PostPage");
    return StatefulWrapper(
      onInit: () async {
        await postState.getPostData();
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
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RoutePath.postEditPage.value, arguments: {
                    "userData": userData,
                    "postState": postState,
                  });
                },
                child: Icon(Icons.edit),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: postData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: Container(
                              color: const Color.fromARGB(255, 179, 175, 174),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      inspect(postData[index].postUserInfo);
                                      if (userData!.uid != postData[index].postUserInfo.uid) {
                                        postState.openDrawer(postData[index].postUserInfo);
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
                                  Text(postData[index].mainMessage),
                                  Text("發文時間 : ${postData[index].postTime}"),
                                  GestureDetector(
                                    onTap: () {
                                      openBottomSheet(postData[index].id);
                                    },
                                    child: Text("コメント${postData[index].commentCount}件すべて見る"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
