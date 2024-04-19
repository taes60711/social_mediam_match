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

import '../skillExChangePage/user_detail.dart';

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

    void changeChoicedPostGoodCount({required PostModel choicedPost, required isGood}) {
      postState.changeChoicedPostGoodCount(choicedPost: choicedPost, isGood: isGood);
    }

    print("NewsPostPage isFirstLoading: ${isFirstLoading}");
    return StatefulWrapper(
      onInit: () async {
        await postState.getPostDataByType(type, searchType: "First");
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
                      changeChoicedPostGoodCount: changeChoicedPostGoodCount,
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
                                if (scrollPosition > max && !isDataAddLoding) {
                                  postState.addData();
                                } else if (scrollPosition < 0 && !isReLoading) {
                                  postState.reLoadingPage();
                                }
                              }
                            }
                            if (scrollNotification is ScrollEndNotification) {
                              if (isDataAddLoding) {
                                postState.getPostDataByType(type, searchType: "AddData");
                              } else if (isReLoading) {
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
                                              Text(
                                                postData[index].mainMessage,
                                                maxLines: 2,
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
