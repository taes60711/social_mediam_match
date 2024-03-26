import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/post_model.dart';

import 'package:social_mediam_match/states/user_state.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/user_icon.dart';

class EditPost extends StatelessWidget {
  final UserState userState;

  const EditPost({super.key, required this.userState});

  @override
  Widget build(BuildContext context) {
    PostModel? choicedPost = userState.choicedPost;
    TextEditingController messageInput = userState.messageInput;
    return StatefulWrapper(
        onInit: () {
          messageInput.text = choicedPost!.mainMessage;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Text("編輯"),
                choicedPost != null
                    ? Container(
                        width: ScreenSize().width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                minLines: 5,
                                maxLines: 255,
                                controller: messageInput,
                                decoration: const InputDecoration(
                                  hintText: "文章內容",
                                  filled: true,
                                ),
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                ElevatedButton(
                    onPressed: () {
                      userState.updatePostData(choicedPost!.id, messageInput.text);
                      userState.globalKey.currentState!.closeEndDrawer();
                    },
                    child: Text("更新"))
              ],
            ),
          ),
        ));
  }
}

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    UserState userState = context.read<UserState>();
    List<PostModel> myAllPosts = context.watch<UserState>().myAllPosts;
    GlobalKey<ScaffoldState> globalKey = context.select((UserState value) => value.globalKey);

    Future<void> exitCheck(int postId) {
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
                  userState.deletePostData(postId);
                  Navigator.of(context).pop();
                  print(postId);
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

    return StatefulWrapper(
      onInit: () {
        userState.getPostDataByUID(userData);
      },
      child: Scaffold(
          key: globalKey,
          endDrawer: EditPost(userState: userState),
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        final before = scrollNotification.metrics.extentBefore;
                        final max = scrollNotification.metrics.maxScrollExtent;
                        if (before == max) {}
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: myAllPosts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 218, 219, 219),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    UserIcon(
                                      iconSize: 50,
                                      image: myAllPosts[index].postUserInfo.image,
                                    ),
                                    Text(myAllPosts[index].postUserInfo.email),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () {
                                              exitCheck(myAllPosts[index].id);
                                            },
                                            icon: Icon(Icons.close)),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(myAllPosts[index].mainMessage),
                                ElevatedButton(
                                  onPressed: () {
                                    userState.postOnChange(myAllPosts[index]);
                                    globalKey.currentState!.openEndDrawer();
                                  },
                                  child: Text("編輯"),
                                ),
                                Text("發文時間 : ${myAllPosts[index].postTime}"),
                                Text("有${myAllPosts[index].commentCount}則留言"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
