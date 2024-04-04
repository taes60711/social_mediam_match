import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/user_icon.dart';
import '../postPage/post_comment.dart';

class EditPost extends StatelessWidget {
  final PostState postState;

  const EditPost({super.key, required this.postState});

  @override
  Widget build(BuildContext context) {
    PostModel? choicedPost = postState.choicedPost;
    TextEditingController messageInput = postState.messageInput;
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () async {
                                  print("Drawer Close");

                                  postState.myPostsGlobalKey.currentState!.closeEndDrawer();
                                },
                                icon: const Icon(Icons.arrow_back_ios_sharp),
                              ),
                            ),
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
                      postState.updatePostData(choicedPost!.id, messageInput.text);
                      postState.myPostsGlobalKey.currentState!.closeEndDrawer();
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
    LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
    VoidCallback gotoFriendPage =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['gotoFriendPage'] as VoidCallback;
    PostState postState = context.read<PostState>();
    List<PostModel> myAllPosts = context.watch<PostState>().myAllPosts;
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.myPostsGlobalKey);
    String myPostEndDrawerType = context.select((PostState value) => value.myPostEndDrawerType);

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
                  postState.deletePostData(postId);
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
        postState.getPostDataByUID(userData, isFirstSearch: true);
      },
      child: Scaffold(
          key: globalKey,
          endDrawer: myPostEndDrawerType == "edit"
              ? EditPost(
                  postState: postState,
                )
              : PostComment(
                  choicedPostData: postState.choicedPost ??
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
                  userData: userData,
                  globalKey: globalKey,
                  gotoFriendPage: gotoFriendPage,
                ),
          body: SafeArea(
            child: Column(
              children: [
                Text("我的文章"),
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
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        postState.postOnChange(myAllPosts[index], "edit");
                                        globalKey.currentState!.openEndDrawer();
                                      },
                                      child: Text("編輯"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        postState.postOnChange(myAllPosts[index], "comment");
                                        globalKey.currentState!.openEndDrawer();
                                      },
                                      child: Text("觀看留言"),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("已 ${myAllPosts[index].viewed} 人瀏覽過"),
                                    Text(" ${myAllPosts[index].good} 個讚"),
                                  ],
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
