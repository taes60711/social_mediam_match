import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../models/user_model.dart';

import '../skillExChangePage/user_detail.dart';

class PostPage extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;

  const PostPage({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    List<PostModel> postData = context.select((PostState value) => value.postData);
    bool isFirstLoading = context.select((PostState value) => value.isFirstLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.globalKey);
    String endDrawerType = context.select((PostState value) => value.endDrawerType);
    LoginUser? otherUser = context.select((PostState value) => value.otherUser);
    PostModel choicedPostData = context.select(
      (PostState value) =>
          value.choicedPostData ??
          PostModel(
              id: -1,
              createdBy: "",
              mainMessage: "",
              commentCount: 0,
              postTime: "",
              postUserInfo: LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: -1),
              viewed: 0,
              good: 0,
              type: 0),
    );

    print("PostPage isFirstLoading: ${isFirstLoading}");
    return StatefulWrapper(
      onInit: () async {
        await postState.getPostData(isFirstSearch: true);
      },
      child: isFirstLoading
          ? const Loading()
          : Scaffold(
              key: globalKey,
              endDrawer: endDrawerType == "userDetail"
                  ? UserDetail(
                      globalKey: globalKey,
                      userData: userData,
                      otherUser: otherUser,
                      gotoFriendPage: gotoFriendPage,
                    )
                  : PostComment(
                      choicedPostData: choicedPostData,
                      userData: userData,
                      globalKey: globalKey,
                      gotoFriendPage: gotoFriendPage,
                    ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        final before = scrollNotification.metrics.extentBefore;
                        final max = scrollNotification.metrics.maxScrollExtent;
                        final scrollPosition = scrollNotification.metrics.pixels;
                        print("scrollPosition : ${scrollPosition}");
                        if (before == max) {
                          postState.getPostData(isFirstSearch: false);
                        } else if (scrollPosition == 0) {
                          postState.getPostData(isFirstSearch: true);
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      // controller: _scrollController,
                      itemCount: postData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          child: GestureDetector(
                            onTap: () async {
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
                                        postState.openDrawer("userDetail", globalKey, otherUser: postData[index].postUserInfo);
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
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
