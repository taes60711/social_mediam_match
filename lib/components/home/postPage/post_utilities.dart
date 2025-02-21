import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'package:social_mediam_match/components/utilities/style/app_image.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/models/rich_text_format.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../global/user_login_status_controller.dart';
import '../../../models/post_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/FadeScalePage/image_view_page.dart';
import '../../utilities/FadeScalePage/video_view_page.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/dialog/confirm_dialog.dart';
import '../../utilities/lodaing_dialog.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/app_colors.dart';
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
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(12)),
        margin: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(12)),
        color: AppColors.black37,
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxWidth(8)),

            /// 文章タイトル＆メッセージ
            Container(
              color: AppColors.transparent,
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
                                  color: AppColors.transparent,
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

                        SizedBox(height: ScreenSize.fitPxWidth(5)),

                        ///文章ビュー

                        Text(
                          data.mainMessage,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(10)),

            /// ファイルメッセージ
            fileMessageItem(
              context,
              padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(28)),
              fileMessage: data.fileMessage,
              videoComponent: (fileMessage, index) {
                String ytId = RichTextFormat().getYtvideoID(fileMessage[index]);
                String ytImag = "https://img.youtube.com/vi/${ytId}/maxresdefault.jpg";
                return messageContainer(
                  width: data.fileMessage.length == 1 ? ScreenSize.fitPxWidth(320) : null,
                  height: data.fileMessage.length == 1 ? ScreenSize.fitPxWidth(180) : null,
                  child: GestureDetector(
                    onTap: () {
                      VideoViewPage(ytId: ytId).show(context);
                      // VideoImageViewPage(fileUrl: fileMessage, initIndex: index).show(context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: ytImag,
                          width: ScreenSize.width,
                          height: ScreenSize.fitPxWidth(190),
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                              baseColor: AppColors.greyColor98,
                              highlightColor: AppColors.greyColor98.withOpacity(.7),
                              child: Container(
                                width: ScreenSize.width,
                                height: ScreenSize.fitPxWidth(120),
                                decoration: BoxDecoration(color: AppColors.greyColor98),
                              ),
                            );
                          },
                        ),
                        Opacity(
                          opacity: .7,
                          child: Container(
                            width: ScreenSize.fitPxWidth(50),
                            height: ScreenSize.fitPxWidth(50),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.black28,
                            ),
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.play,
                                size: ScreenSize.fitPxWidth(20),
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: ScreenSize.fitPxWidth(12)),

            ///BottomBar
            Padding(
              padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(28)),
              child: Row(
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
                  ///
                  Row(
                    children: [
                      Image.asset(
                        AppImage.heartFillIcon,
                        color: AppColors.redColor,
                        width: ScreenSize.fitPxWidth(14),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Text("${data.good}", style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                    ],
                  ),
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
                      color: AppColors.transparent,
                      child: Icon(
                        FontAwesomeIcons.arrowUpRightFromSquare,
                        color: AppColors.greyColor180A221,
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
            ),
            SizedBox(height: ScreenSize.fitPxWidth(8)),
          ],
        ),
      ),
    );
  }

  /// 文章画像＆YTビデオ
  Widget fileMessageItem(
    BuildContext context, {
    EdgeInsetsGeometry? padding,
    required List<String> fileMessage,
    required Widget Function(List<String> fileMessage, int index) videoComponent,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: fileMessage.asMap().entries.map((e) {
          int index = e.key;

          String value = e.value;
          String messageType = "null";

          if (value == "") {
          } else if (value.contains("youtube")) {
            messageType = "ytVideo";
          } else {
            messageType = "img";
          }

          switch (messageType) {
            case "ytVideo":
              return videoComponent(fileMessage, index);
            case "img":
              String realImg = value;
              if (value.contains(APIHttpController.databaseDomainStr)) {
                realImg = RichTextFormat().mappingIPAndPort(value);
              }

              return messageContainer(
                width: fileMessage.length == 1 ? ScreenSize.fitPxWidth(320) : null,
                height: fileMessage.length == 1 ? ScreenSize.fitPxWidth(180) : null,
                child: GestureDetector(
                  onTap: () {
                    // VideoImageViewPage(fileUrl: fileMessage, initIndex: index).show(context);
                    ImageViewPage(imgUrl: realImg).show(context);
                  },
                  child: CachedNetworkImage(
                    imageUrl: realImg,
                    width: ScreenSize.width,
                    height: ScreenSize.fitPxWidth(190),
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: AppColors.greyColor98,
                        highlightColor: AppColors.greyColor98.withOpacity(.7),
                        child: Container(
                          width: ScreenSize.width,
                          height: ScreenSize.fitPxWidth(120),
                          decoration: BoxDecoration(color: AppColors.greyColor98),
                        ),
                      );
                    },
                  ),
                ),
              );
            default:
              return Container();
          }
        }).toList(),
      ),
    );
  }

  ///
  Widget messageContainer({double? width, double? height, required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.greyColor57),
          ),
          width: width ?? ScreenSize.fitPxWidth(250),
          height: height ?? ScreenSize.fitPxWidth(150),
          child: child,
        ),
      ),
    );
  }

  ///文章作るボタン
  static Widget postCreateButton(BuildContext context, WidgetRef ref, {PostBoard? postBoard}) {
    return MainBtn(
      onPress: () {
        if (UserLoginStatusController().isGuest()) {
          ConfirmDilaog(
              title: "提示",
              content: "請先登入",
              conirmFunc: () {
                UserLoginStatusController().guestLogOut(
                  attachFunc: () {
                    HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
                  },
                );
              }).show(context);
          return;
        }
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
  Widget iconWithText({
    required IconData iconData,
    Color? iconColor,
    required String text,
    TextStyle? style,
    double? iconSize,
  }) {
    return Container(
      color: AppColors.transparent,
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(3), vertical: ScreenSize.fitPxWidth(3)),
      child: Row(
        children: [
          Icon(
            iconData,
            size: iconSize ?? ScreenSize.fontSize14,
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
    String sharePostUrl = "https://${APIHttpController.shareDomain}/post/$postId";
    LoadingDialog().show();
    await Share.share(sharePostUrl);
    LoadingDialog().close();
  }
}
