import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/style/screen_size.dart';

class PostPage extends StatelessWidget {
  final LoginUser? userData;
  const PostPage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    List<PostModel> postData = context.select((PostState value) => value.postData);

    openBottomSheet(int postId) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => PostState(),
            child: Builder(builder: (context) {
              PostState postState = context.read<PostState>();
              List<PostCommentModel> postCommentData = context.select((PostState value) => value.postCommentData);
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
                                      Text(postCommentData[index].postTime)
                                    ],
                                  ),
                                );
                              },
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

    return StatefulWrapper(
      onInit: () async {
        await postState.getPostData();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              RoutePath.postEditPage.value,
              arguments: userData,
            );
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
                            Text(postData[index].createdBy),
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
