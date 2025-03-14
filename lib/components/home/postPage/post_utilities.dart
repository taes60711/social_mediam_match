import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment_page.dart';

import 'package:social_mediam_match/components/utilities/style/app_image.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/models/rich_text_format.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../global/user_login_status_controller.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/FadeScalePage/video_image_view_page.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/dialog/confirm_dialog.dart';
import '../../utilities/lodaing_dialog.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/app_colors.dart';
import '../../utilities/user_icon.dart';
import 'post_manager/post_bottom_sheet.dart';
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
        viewModel.postDetailPageInit(postListController, data, dataIndex, autoFocusKeyBoard: false);
      },
      child: Container(
        width: ScreenSize.width,
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
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
                              data.postUserInfo.name ?? "用戶已不存在",
                              style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(4)),

                            const Expanded(child: SizedBox(width: 1)),
                            GestureDetector(
                              onTap: () {
                                ref.read(choicedPostProvider.notifier).update((state) => data);

                                if (data.postUserInfo.uid == ref.read(loginUserData).uid) {
                                  ///右上のアイコンのボタン
                                  PostManagerBtmSheet(postListController, dataIndex: dataIndex).show(context);
                                } else {
                                  PostBtmSheet(choicedData: ref.read(choicedPostProvider.notifier).state).show(context);
                                }
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
                return messageVideoItem(
                  context,
                  ytImag: ytImag,
                  fileMessage: fileMessage,
                  index: index,
                );
              },
            ),

            SizedBox(height: ScreenSize.fitPxWidth(12)),

            ///BottomBar
            Padding(
              padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(28)),
              child: Row(
                children: [
                  /// 看板
                  PostViewUtilities().iconWithText(
                    iconData: typeData.iconData,
                    iconColor: AppColors.whiteColor.withOpacity(0.8),
                    iconSize: ScreenSize.fontSize14,
                    style: TextStyle(
                      fontSize: ScreenSize.fontSize12,
                      color: AppColors.whiteColor,
                    ),
                    padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                    text: typeData.chineseName,
                  ),

                  ///いいね数
                  MainBtn(
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
                      ProfileData userData = ref.read(loginUserData);
                      if (data.postUserInfo.uid == userData.uid) {
                        return;
                      }

                      viewModel.listPostGoodOnChange(
                        data.loginUserIsGood,
                        postData: data,
                        dataIndex: dataIndex,
                        postListController: postListController,
                      );
                    },
                    child: PostViewUtilities().iconWithText(
                      image: data.loginUserIsGood ? AppImage.heartFillIcon : AppImage.heartLinerIcon,
                      iconColor: data.loginUserIsGood ? AppColors.redColor : AppColors.greyColor130,
                      text: "${data.good}",
                    ),
                  ),

                  ///コメント数
                  MainBtn(
                    onPress: () {
                      ref.read(choicedPostProvider.notifier).update((state) => data);

                      ///詳細ページに遷移
                      PostCommentPage(dataIndex: dataIndex).show(context);
                    },
                    child: PostViewUtilities().iconWithText(
                      iconData: FontAwesomeIcons.commentDots,
                      iconColor: Colors.blueAccent,
                      text: "${data.commentCount}",
                    ),
                  ),

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
    if (fileMessage.length == 1) {
      String messageType = getMessageType(fileMessage.first);
      switch (messageType) {
        case "ytVideo":
          return messageContainer(
            width: ScreenSize.width,
            height: ScreenSize.fitPxWidth(180),
            child: videoComponent(fileMessage, 0),
          );
        case "img":
          return messageContainer(
            width: ScreenSize.width,
            height: ScreenSize.fitPxWidth(180),
            child: messageImgItem(
              context,
              imgUrl: fileMessage.first,
              fileMessage: fileMessage,
              index: 0,
            ),
          );

        default:
          return Container();
      }
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          children: fileMessage.asMap().entries.map((e) {
            int index = e.key;
            String value = e.value;
            String messageType = getMessageType(value);

            switch (messageType) {
              case "ytVideo":
                return messageContainer(
                  child: videoComponent(fileMessage, index),
                );
              case "img":
                return messageContainer(
                  child: messageImgItem(
                    context,
                    imgUrl: value,
                    fileMessage: fileMessage,
                    index: index,
                  ),
                );

              default:
                return Container();
            }
          }).toList(),
        ),
      );
    }
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

  ///
  Widget messageImgItem(
    BuildContext context, {
    required String imgUrl,
    required List<String> fileMessage,
    required int index,
  }) {
    String realImg = imgUrl;
    if (imgUrl.contains(APIHttpController.databaseDomainStr)) {
      realImg = RichTextFormat().mappingIPAndPort(imgUrl);
    }
    return GestureDetector(
      onTap: () {
        VideoImageViewPage(fileStr: fileMessage, initIndex: index).show(context);
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
    );
  }

  Widget messageVideoItem(
    BuildContext context, {
    required String ytImag,
    required List<String> fileMessage,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        VideoImageViewPage(fileStr: fileMessage, initIndex: index).show(context);
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
    IconData? iconData,
    String? image,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    required String text,
    TextStyle? style,
    double? iconSize,
  }) {
    Widget iconWidget = Container();

    if (image != null) {
      iconWidget = Image.asset(
        image,
        color: iconColor,
        width: iconSize ?? ScreenSize.fontSize16,
      );
    } else {
      iconWidget = Icon(
        iconData,
        color: iconColor,
        size: iconSize ?? ScreenSize.fontSize16,
      );
    }

    return Container(
      color: AppColors.transparent,
      padding: padding ??
          EdgeInsets.only(
            left: ScreenSize.fitPxWidth(10),
            right: ScreenSize.fitPxWidth(10),
            top: ScreenSize.fitPxWidth(5),
            bottom: ScreenSize.fitPxWidth(5),
          ),
      child: Row(
        children: [
          iconWidget,
          SizedBox(width: ScreenSize.fitPxWidth(5)),
          Text(
            text,
            style: style ??
                TextStyle(
                  fontSize: ScreenSize.fontSize12,
                  color: AppColors.whiteColor,
                ),
          ),
        ],
      ),
    );
  }

  /// 文章画像＆YTビデオの種類取得する
  String getMessageType(String fileUrl) {
    String messageType = "null";

    if (fileUrl == "") {
    } else if (fileUrl.contains("youtube")) {
      messageType = "ytVideo";
    } else {
      messageType = "img";
    }
    return messageType;
  }

  Future<void> sharePost({required int postId}) async {
    String sharePostUrl = "https://${APIHttpController.shareDomain}/post/$postId";
    LoadingDialog().show();
    await Share.share(sharePostUrl);
    LoadingDialog().close();
  }
}
