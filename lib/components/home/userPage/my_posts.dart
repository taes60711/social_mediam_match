import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/home/postPage/post_body.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../postPage/post_comment.dart';

class EditPost extends StatelessWidget {
  final PostState postState;

  const EditPost({super.key, required this.postState});

  @override
  Widget build(BuildContext context) {
    PostModel? choicedPost = postState.choicedPost;
    QuillEditorController controller = QuillEditorController();
    return Scaffold(
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
                        RichTextEditor(controller: controller, content: choicedPost.mainMessage)
                      ],
                    ),
                  )
                : Container(),
            ElevatedButton(
                onPressed: () async {
                  String content = await controller.getText();
                  postState.updatePostData(choicedPost!.id, content);
                  postState.myPostsGlobalKey.currentState!.closeEndDrawer();
                },
                child: const Text("更新"))
          ],
        ),
      ),
    );
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

    void changeChoicedPostGoodCount({required PostModel choicedPost, required isGood}) {
      postState.changeChoicedPostGoodCount(choicedPost: choicedPost, isGood: isGood);
    }

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
            ? EditPost(postState: postState)
            : PostComment(
                choicedPostData: postState.choicedPost ??
                    PostModel(
                        id: -1,
                        createdBy: "",
                        title: "",
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
                changeChoicedPostGoodCount: changeChoicedPostGoodCount,
              ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenSize().width * 0.33,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(width: ScreenSize().width * 0.33, child: const Center(child: Text("我的文章"))),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myAllPosts.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        PostBody(
                          postData: myAllPosts[index],
                          postState: postState,
                          globalKey: globalKey,
                          userData: userData,
                          gotoFriendPage: gotoFriendPage,
                          bottomSheetFuncs: [
                            PostOption(
                                icon: Icons.edit,
                                buttonFunc: () async {
                                  Navigator.pop(context);
                                  await postState.postOnChange(myAllPosts[index], "edit");
                                  globalKey.currentState!.openEndDrawer();
                                },
                                funcText: '編輯文章'),
                            PostOption(
                                icon: FontAwesomeIcons.commentSlash,
                                buttonFunc: () {
                                  Navigator.pop(context);
                                  exitCheck(myAllPosts[index].id);
                                },
                                funcText: '刪除'),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
