import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/style/app_image.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../global/user_login_status_controller.dart';
import '../../../models/post_model.dart';
import '../../../models/rich_text_format.dart';
import '../../../models/user_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/FadeScalePage/video_view_page.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/endDrawers/base_end_drawer.dart';
import '../../utilities/main_button.dart';
import '../../utilities/user_icon.dart';
import 'post_comment_page.dart';

class PostDetailPage extends BaseEndDrawer {
  final StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController;
  final int dataIndex;

  PostDetailPage({required this.dataIndex, this.postListController});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);

    viewModel.init();
  }

  @override
  Widget build(ref) {
    PostModel choiceData = ref.watch(choicedPostProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///タイトルバー
        BaseTopBar(
          backFunc: () => closePage(),
          title: choiceData.title,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ユーザデータ
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ///ユーザー詳細ページに遷移
                          UserProfileAllInfoBottomSheet(userData: choiceData.postUserInfo).show(context);
                        },
                        child: UserIcon(
                          iconSize: ScreenSize.fitPxWidth(30),
                          image: choiceData.postUserInfo.image,
                        ),
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
                            DateFormatUtilities().format(choiceData.postTime),
                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),

                  /// MainMessage
                  Text(
                    choiceData.mainMessage,
                    style: TextStyle(fontSize: ScreenSize.fontSize16, color: AppColors.whiteColor),
                  ),

                  SizedBox(height: ScreenSize.fitPxWidth(10)),

                  /// ファイルメッセージ
                  PostViewUtilities().fileMessageItem(
                    context,
                    fileMessage: choiceData.fileMessage,
                    videoComponent: (String data) {
                      String ytId = RichTextFormat().getYtvideoID(data);
                      return PostViewUtilities().messageContainer(
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: ytId,
                            flags: const YoutubePlayerFlags(
                              disableDragSeek: true,
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                          onReady: () => {},
                          bottomActions: [
                            PlaybackSpeedButton(
                              icon: Icon(
                                FontAwesomeIcons.gear,
                                size: ScreenSize.fontSize18,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            ProgressBar(isExpanded: true),
                            RemainingDuration(),
                            GestureDetector(
                              onTap: () {
                                final Uri _url = Uri.parse("https://www.youtube.com/watch?v=$ytId");
                                launchUrl(_url);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  FontAwesomeIcons.windowRestore,
                                  size: ScreenSize.fontSize18,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            MainBtn(
                              onPress: () {
                                VideoViewPage(ytId: ytId).show(context);
                              },
                              child: Icon(
                                Icons.fullscreen,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: ScreenSize.fitPxHeight(10)),

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
                            iconSize: ScreenSize.fitPxWidth(20),
                            style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),

                        GestureDetector(
                          onTap: () {
                            if (UserLoginStatusController().isGuest()) {
                              ConfirmDilaog(
                                  title: "提示",
                                  content: "請先登入",
                                  conirmFunc: () {
                                    UserLoginStatusController().guestLogOut(
                                      attachFunc: () {
                                        closePage();
                                        HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
                                      },
                                    );
                                  }).show(context);
                              return;
                            }

                            ///コメントページに遷移する
                            PostCommentPage(dataIndex: dataIndex, postListController: postListController).show(context);
                          },
                          child: Container(
                            color: AppColors.transparent,
                            padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(7)),
                            child: PostViewUtilities().iconWithText(
                                iconData: FontAwesomeIcons.commentDots,
                                iconColor: AppColors.greyColor130,
                                text: "${choiceData.commentCount}",
                                iconSize: ScreenSize.fitPxWidth(20),
                                style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                          ),
                        ),

                        ///いいね数
                        GestureDetector(
                          onTap: () {
                            if (UserLoginStatusController().isGuest()) {
                              ConfirmDilaog(
                                  title: "提示",
                                  content: "請先登入",
                                  conirmFunc: () {
                                    UserLoginStatusController().guestLogOut(
                                      attachFunc: () {
                                        closePage();
                                        HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
                                      },
                                    );
                                  }).show(context);
                              return;
                            }
                            ProfileData userData = ref.read(loginUserData);
                            if (choiceData.postUserInfo.uid == userData.uid) {
                              return;
                            }
                            viewModel.lookingPostGoodOnChange(
                              ref.read(choicedPostIsGoodProvider.notifier).state,
                              dataIndex: dataIndex,
                              postListController: postListController,
                            );
                          },
                          child: Container(
                            color: AppColors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
                            child: Row(
                              children: [
                                Image.asset(
                                  ref.read(choicedPostIsGoodProvider.notifier).state
                                      ? AppImage.heartFillIcon
                                      : AppImage.heartLinerIcon,
                                  color: ref.read(choicedPostIsGoodProvider.notifier).state
                                      ? AppColors.redColor
                                      : AppColors.greyColor130,
                                  width: ScreenSize.fitPxWidth(20),
                                ),
                                SizedBox(width: ScreenSize.fitPxWidth(5)),
                                Text("${choiceData.good}",
                                    style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                              ],
                            ),
                          ),
                        ),
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
        Builder(builder: (context) {
          ProfileData userData = ref.watch(loginUserData);
          return GestureDetector(
            onTap: () {
              ///コメントページに遷移する
              PostCommentPage(dataIndex: dataIndex, postListController: postListController).show(context);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.greyColor54,
                  ),
                ),
              ),
              height: ScreenSize.fitPxHeight(65),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(12)),
                child: Column(
                  children: [
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                    Row(
                      children: [
                        UserIcon(
                          iconSize: ScreenSize.fitPxHeight(25),
                          image: userData.image,
                        ),
                        SizedBox(width: ScreenSize.fitPxHeight(10)),
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
                                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(12)),

                        ///分享按鈕
                        GestureDetector(
                          onTap: () async {
                            await PostViewUtilities().sharePost(postId: choiceData.id);
                          },
                          child: PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.arrowUpRightFromSquare,
                            iconColor: AppColors.greyColor180A221,
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
          );
        }),
      ],
    );
  }

  // Widget _messageContainer({required Widget child}) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(10)),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(13),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(13),
  //           border: Border.all(color: AppColors.greyColor57),
  //         ),
  //         width: ScreenSize.fitPxWidth(250),
  //         height: ScreenSize.fitPxWidth(150),
  //         child: child,
  //       ),
  //     ),
  //   );
  // }
}
