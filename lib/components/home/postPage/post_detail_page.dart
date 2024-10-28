import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../models/post_model.dart';
import '../../utilities/endDrawers/base_end_drawer.dart';
import '../../utilities/user_icon.dart';
import 'post_comment_page.dart';
import 'post_main_page.dart';

class PostDetailPage extends BaseEndDrawer {
  @override
  Future<void> initState(WidgetRef ref) async {}

  @override
  bool needWaitOpenPage() {
    return true;
  }

  @override
  Widget build(ref) {
    PostModel choiceData = ref.read(choicedPostProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
          title: choiceData.title,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// ユーザデータ
                  Row(
                    children: [
                      UserIcon(
                        iconSize: ScreenSize.fitPxWidth(30),
                        image: choiceData.postUserInfo.image,
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            choiceData.postUserInfo.name ?? "",
                            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                          ),
                          Text(
                            choiceData.postTime,
                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                          ),
                        ],
                      )
                    ],
                  ),

                  /// MainMessage
                  RichTextView(content: choiceData.mainMessage),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),

                  ///文章インフォ
                  Padding(
                    padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(5)),
                    child: Row(
                      children: [
                        ///View数
                        PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.eye,
                            iconColor: AppColors.greyColor130,
                            text: "${choiceData.viewed}",
                            style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                        SizedBox(width: ScreenSize.fitPxWidth(10)),
                        PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.commentDots,
                            iconColor: AppColors.greyColor130,
                            text: "${choiceData.commentCount}",
                            style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                        SizedBox(width: ScreenSize.fitPxWidth(12)),

                        ///いいね数
                        PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.heart,
                            iconColor: AppColors.greyColor130,
                            text: "${choiceData.good}",
                            style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                        SizedBox(width: ScreenSize.fitPxWidth(12)),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(10)),
                ],
              ),
            ),
          ),
        ),

        ///コメント
        GestureDetector(
          onTap: () {
            PostCommentPage().show(context);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.greyColor54,
                ),
              ),
            ),
            height: ScreenSize.fitPxHeight(45),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(12)),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenSize.fitPxHeight(5),
                  ),
                  Row(
                    children: [
                      Container(
                        width: ScreenSize.fitPxHeight(25),
                        height: ScreenSize.fitPxHeight(25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxHeight(5)),
                      Expanded(
                        child: Container(
                          height: ScreenSize.fitPxHeight(30),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor57,
                            borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(8)),
                            child: Text(
                              "留言",
                              style: TextStyle(color: AppColors.greyColor130, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(12)),

                      ///分享按鈕
                      GestureDetector(
                        onTap: () {},
                        child: PostViewUtilities().iconWithText(
                          iconData: FontAwesomeIcons.arrowUpRightFromSquare,
                          iconColor: Color.fromARGB(221, 180, 179, 179),
                          text: "分享",
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(12)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
