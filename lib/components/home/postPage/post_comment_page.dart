import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/post_model.dart';
import '../../../provider/friend_provider.dart';
import '../../../provider/post/post_comment_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class PostCommentPage extends StatelessWidget {
  const PostCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel viewChoicedPost = context.read<PostCommentProvider>().viewChoicedPost;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ScreenSize.width,
                    padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: const Color.fromARGB(255, 236, 157, 120),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<FriendProvider>().changeEndDrawerStatus(
                                      UserDetailEndDrawerType.open,
                                      viewChoicedPost.postUserInfo,
                                    );
                              },
                              child: UserIcon(
                                iconSize: 35,
                                image: viewChoicedPost.postUserInfo.image,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              viewChoicedPost.postUserInfo.name != ""
                                  ? viewChoicedPost.postUserInfo.name ?? ""
                                  : viewChoicedPost.postUserInfo.email,
                              style: TextStyle(fontSize: 12, color: normalTextColor),
                            ),
                          ],
                        ),
                        Text(
                          "${viewChoicedPost.postTime}前",
                          style: TextStyle(fontSize: 12, color: normalTextColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichTextView(content: viewChoicedPost.mainMessage),
                  const SizedBox(height: 10),
                  Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
                  // Row(
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () async {
                  //         isGood
                  //             ? await postState.updatePostGood(choicedPostData.id)
                  //             : await postState.updatePostGood(choicedPostData.id, userUID: userData.uid);
                  //         changeChoicedPostGoodCount(choicedPost: choicedPostData, isGood: isGood);
                  //       },
                  //       child: isGood ? Text("收回讚") : Text("讚"),
                  //     ),
                  //     Text(" ${choicedPostData.good} 個讚"),
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
