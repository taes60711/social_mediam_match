import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/api_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../enum/date_format_utilities.dart';
import '../../../../global.dart';
import '../../../../models/post_model.dart';
import '../../../../models/rich_text_format.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/post_service.dart';
import '../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../utilities/FadeScalePage/video_view_page.dart';
import '../../../utilities/appBar/basic_top_bar.dart';
import '../../../utilities/endDrawers/base_end_drawer.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';
import '../../../utilities/user_icon.dart';
import '../../postPage/post_utilities.dart';

class MyNotificationPostPage extends BaseEndDrawer {
  final String postId;
  MyNotificationPostPage({required this.postId});

  @override
  bool needWaitOpenPage() {
    return true;
  }

  @override
  Future<void> dispose(WidgetRef ref) async {
    ref.read(notifiProfilePageIsOpen.notifier).update((state) => false);
  }

  late PostViewModel viewModel;

  @override
  Widget build(ref) {
    return APIPage<PostModel>(
      noDataCondition: (data) {
        return data.id == -1;
      },
      apiFunc: () async {
        return await PostService().getPostDataByPostId(int.parse(postId));
      },
      initFunc: (PostModel data) async {
        viewModel = PostViewModel(ref: ref, context: context, render: render);
      },
      child: (PostModel data) {
        return Column(
          children: [
            ///タイトルバー
            BaseTopBar(
              backFunc: () => closePage(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ユーザデータ
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ///ユーザー詳細ページに遷移
                              UserProfileAllInfoBottomSheet(userData: data.postUserInfo).show(context);
                            },
                            child: UserIcon(
                              iconSize: ScreenSize.fitPxWidth(30),
                              image: data.postUserInfo.image,
                            ),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(5)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.postUserInfo.name ?? "用戶已不存在",
                                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                              ),
                              Text(
                                DateFormatUtilities().format(data.postTime),
                                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                              ),
                            ],
                          )
                        ],
                      ),

                      /// MainMessage
                      Text(
                        data.mainMessage,
                        style: TextStyle(fontSize: ScreenSize.fontSize16, color: AppColors.whiteColor),
                      ),

                      SizedBox(height: ScreenSize.fitPxWidth(10)),

                      /// ファイルメッセージ
                      PostViewUtilities().fileMessageItem(
                        context,
                        fileMessage: data.fileMessage,
                        videoComponent: (List<String> data, index) {
                          String ytId = RichTextFormat().getYtvideoID(data[index]);
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      nodataWidget: Column(
        children: [
          ///タイトルバー
          BaseTopBar(
            backFunc: () => closePage(),
          ),
          Expanded(
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
        ],
      ),
    );
  }
}
