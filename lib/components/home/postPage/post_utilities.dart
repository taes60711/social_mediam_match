import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../models/post_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/lodaing_dialog.dart';
import '../../utilities/main_button.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_manager/post_create_page.dart';
import 'post_manager/post_manager_bottom_sheet.dart';

class PostViewUtilities {
  ///データなレイアウト
  static Widget noPostData() {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.height,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
              child: Icon(
                FontAwesomeIcons.commentSlash,
                size: 50,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            Text(
              "沒有文章",
              style: TextStyle(
                fontSize: ScreenSize.fontSize20,
                color: AppColors.greyColor130,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topPadding(double bottomBarPos, bool haveTopPost) {
    return AnimatedContainer(
      height: bottomBarPos != ScreenSize.fitPxHeight(-60)
          ? ScreenSize.fitPxHeight(haveTopPost ? 115 : 70)
          : ScreenSize.fitPxHeight(70),
      duration: const Duration(milliseconds: 150),
    );
  }

  Widget postItemContent(
    PostViewModel viewModel,
    StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>> postListController, {
    required PostModel data,
    required int dataIndex,
  }) {
    WidgetRef ref = viewModel.ref;
    BuildContext context = viewModel.context;

    PostBoard typeData = ref.read(allPostBoardListData).firstWhere(
          (e) => e.id == data.type,
          orElse: () => PostBoard(),
        );
    return MainBtn(
      onPress: () {
        ///詳細ページに遷移
        viewModel.postDetailPageInit(postListController, data, dataIndex);
      },
      child: Container(
        width: ScreenSize.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.only(bottom: 10),
        color: AppColors.black37,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                ///ユーザー詳細ページに遷移
                UserProfileAllInfoBottomSheet(userData: data.postUserInfo).show(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(2), right: ScreenSize.fitPxWidth(5)),
                child: UserIcon(
                  iconSize: 30,
                  image: data.postUserInfo.image,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ///名前
                      Text(
                        data.postUserInfo.name ?? "",
                        style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(4)),

                      const Expanded(child: SizedBox(width: 1)),
                      Visibility(
                        visible: data.postUserInfo.uid == ref.read(loginUserData).uid,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(choicedPostProvider.notifier).update((state) => data);

                            ///右上のアイコンのボタン
                            PostManagerBtmSheet(postListController, dataIndex: dataIndex).show(context);
                          },
                          child: Container(
                            width: 30,
                            alignment: Alignment.centerRight,
                            color: Colors.transparent,
                            child: Icon(
                              FontAwesomeIcons.ellipsis,
                              color: AppColors.greyColor130,
                              size: ScreenSize.fontSize16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: ScreenSize.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),

                  ///文章ビュー
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: RichTextView(
                        content: data.mainMessage,
                        isPreView: true,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                  Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: ScreenSize.fitPxHeight(15),
                            height: ScreenSize.fitPxHeight(15),
                            child: Icon(
                              typeData.iconData,
                              color: AppColors.whiteColor.withOpacity(0.8),
                              size: ScreenSize.fontSize14,
                            ),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(5)),
                          Text(
                            typeData.chineseName,
                            style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),

                      ///いいね数
                      PostViewUtilities().iconWithText(
                          iconData: FontAwesomeIcons.heart,
                          iconColor: const Color.fromARGB(255, 248, 110, 110),
                          text: "${data.good}",
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),

                      ///コメント数
                      PostViewUtilities().iconWithText(
                          iconData: FontAwesomeIcons.commentDots,
                          iconColor: Colors.blueAccent,
                          text: "${data.commentCount}",
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),

                      ///ビュー数
                      PostViewUtilities().iconWithText(
                          iconData: FontAwesomeIcons.eye,
                          iconColor: const Color.fromARGB(255, 110, 124, 129),
                          text: "${data.viewed}",
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),

                      SizedBox(width: ScreenSize.fitPxWidth(13)),

                      ///シャアボタン
                      GestureDetector(
                        onTap: () async {
                          await sharePost(postId: data.id);
                        },
                        child: Container(
                          width: 30,
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: Icon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            color: const Color.fromARGB(221, 180, 179, 179),
                            size: ScreenSize.fontSize14,
                          ),
                        ),
                      ),

                      const Expanded(child: SizedBox(width: 1)),

                      ///期日
                      Text(
                        DateFormatUtilities().format(data.postTime),
                        style: TextStyle(fontSize: ScreenSize.fontSize10, color: AppColors.greyColor130),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///文章作るボタン
  static Widget postCreateButton(BuildContext context, {PostBoard? postBoard}) {
    return MainBtn(
      onPress: () {
        PostCreatePage(postBoard: postBoard).show(context);
      },
      child: Container(
        width: ScreenSize.fitPxWidth(40),
        height: ScreenSize.fitPxWidth(40),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor,
        ),
        child: Icon(
          FontAwesomeIcons.pen,
          size: ScreenSize.fontSize14,
          color: AppColors.orangeColor,
        ),
      ),
    );
  }

  ///アイコン＆文字
  Widget iconWithText({required IconData iconData, Color? iconColor, required String text, TextStyle? style}) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(3), vertical: ScreenSize.fitPxWidth(3)),
      child: Row(
        children: [
          Icon(
            iconData,
            size: ScreenSize.fontSize14,
            color: iconColor,
          ),
          SizedBox(width: ScreenSize.fitPxWidth(5)),
          Text(
            text,
            style: style ?? const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Future<void> sharePost({required int postId}) async {
    String sharePostUrl = "https://$domain/post/$postId";
    LoadingDialog().show();
    await Share.share(sharePostUrl);
    LoadingDialog().close();
  }
}
