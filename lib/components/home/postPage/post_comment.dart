import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => PostState(),
      child: Builder(builder: (context) {
        PostState postState = context.read<PostState>();
        List<PostCommentModel> postCommentData = context.watch<PostState>().postCommentData;
        TextEditingController postCommentInput = context.select((PostState value) => value.postCommentInput);
        return Scaffold(
          body: StatefulWrapper(
            onInit: () async {
              await postState.getPostCommentData(choicedPostData.id);
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
                          Row(
                            children: [
                              UserIcon(
                                iconSize: 50,
                                image: choicedPostData.postUserInfo.image,
                              ),
                              Text(choicedPostData.postUserInfo.email),
                            ],
                          ),
                          Text(choicedPostData.mainMessage),
                          Text("發文時間 : ${choicedPostData.postTime}"),
                        ],
                      ),
                    ),
                  ),
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
                          postState.createPostComment(choicedPostData.id, userData.uid, postCommentInput.text);
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
        );
      }),
    );
  }
}
