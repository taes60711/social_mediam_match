import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';

import '../../../models/post_model.dart';
import '../../../provider/post/post_comment_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel viewChoicedPost = context.read<PostCommentProvider>().viewChoicedPost;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
        child: SingleChildScrollView(
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
                            openUserDetailEndDrawer(context: context, otherUserData: viewChoicedPost.postUserInfo);
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
                      "${viewChoicedPost.postTime}${tr("skExChpage_beforDays")}",
                      style: TextStyle(fontSize: 12, color: normalTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichTextView(content: viewChoicedPost.mainMessage),
              const SizedBox(height: 10),
              Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      bool isGood = context.select((PostProvider value) => value.isGood);
                      return GestureDetector(
                        onTap: () {
                          PostViewModel(postContext: context).updatePostGood(isGood: isGood, viewChoicedPost: viewChoicedPost);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: .7, color: normalBgColor), borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                isGood ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
                                color: normalBgColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      int choicedPostGoodCount = context.select((PostCommentProvider value) => value.viewChoicedPost.good);
                      return Text(
                        "$choicedPostGoodCount",
                        style: TextStyle(
                          color: normalBgColor,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  PostViewModel(postContext: context).showPostCommentPageSheet(choicedPost: viewChoicedPost);
                },
                child: Container(
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  color: normalBgColor2,
                  child: Text(
                    "${viewChoicedPost.commentCount}則回復",
                    style: TextStyle(color: normalTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
