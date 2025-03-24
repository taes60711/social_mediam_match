import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/app_image.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../../services/post_service.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/endDrawers/base_end_drawer.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/main_button.dart';
import '../../utilities/user_icon.dart';
import 'post_manager/my_post_bottom_sheet.dart';
import 'post_manager/post_bottom_sheet.dart';

class PostDetailPage extends BaseEndDrawer {
  final StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController;
  final int dataIndex;
  final bool autoFocusKeyBoard;

  PostDetailPage({required this.dataIndex, this.postListController, this.autoFocusKeyBoard = true});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  bool isEditStart = false;
  TextEditingController commentController = TextEditingController();
  int choicedCommentEditDataIndex = -1;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);
    viewModel.init();
  }

  @override
  Future<void> dispose(WidgetRef ref) async {
    ref.read(postCommentListControllerProvider).listData.clear();
  }

  @override
  Widget build(ref) {
    ProfileData userData = ref.watch(loginUserData);
    PostModel choiceData = ref.watch(choicedPostProvider);
    PostBoard typeData = ref.read(allPostBoardListData).firstWhere(
          (e) => e.id == choiceData.type,
          orElse: () => PostBoard(),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///タイトルバー
        BaseTopBar(
          backFunc: () => closePage(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
            child: APIListWidget(
                size: 7,
                isNeedToTopBtn: false,
                apiFunc: (page, size) {
                  return PostService().getPostCommentData(page, size, choiceData.id);
                },
                listControllerProvider: postCommentListControllerProvider,
                noDataWidget: Center(
                  child: Text(
                    "目前沒有任何留言",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                  ),
                ),
                headerWidget: Column(
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                choiceData.postUserInfo.name ?? "用戶已不存在",
                                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                              ),
                              Text(
                                DateFormatUtilities().format(choiceData.postTime),
                                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (choiceData.postUserInfo.uid == ref.read(loginUserData).uid && postListController != null) {
                              ///右上のアイコンのボタン
                              MyPostBtmSheet(postListController!, dataIndex: dataIndex).show(context);
                            } else {
                              PostBtmSheet(choicedData: ref.read(choicedPostProvider.notifier).state).show(context);
                            }
                          },
                          child: Container(
                            width: ScreenSize.fitPxWidth(35),
                            height: ScreenSize.fitPxWidth(35),
                            alignment: Alignment.topRight,
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
                    ),

                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    ///文章インフォ
                    Padding(
                      padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(5)),
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
                          GestureDetector(
                            onTap: () {
                              HomeGlobalViewModel().needLoginCheckFunc(berforeCloseConfirmDialogFunc: () {
                                closePage();
                              }, func: () {
                                ProfileData userData = ref.read(loginUserData);
                                if (choiceData.postUserInfo.uid == userData.uid) {
                                  return;
                                }
                                viewModel.lookingPostGoodOnChange(
                                  choiceData.loginUserIsGood,
                                  dataIndex: dataIndex,
                                  postListController: postListController,
                                );
                              });
                            },
                            child: PostViewUtilities().iconWithText(
                              image: choiceData.loginUserIsGood ? AppImage.heartFillIcon : AppImage.heartLinerIcon,
                              iconColor: choiceData.loginUserIsGood ? AppColors.redColor : AppColors.greyColor130,
                              text: "${choiceData.good}",
                            ),
                          ),

                          PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.commentDots,
                            iconColor: Colors.blueAccent,
                            text: "${choiceData.commentCount}",
                          ),

                          ///View数
                          PostViewUtilities().iconWithText(
                            iconData: FontAwesomeIcons.eye,
                            iconColor: AppColors.greyColor130,
                            text: "${choiceData.viewed}",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                  ],
                ),
                itemChild: (data, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///ユーザアイコン
                        MainBtn(
                          onPress: () {
                            UserProfileAllInfoBottomSheet(userData: data.commentUserInfo).show(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(3)),
                            child: UserIcon(
                              iconSize: 30,
                              image: data.commentUserInfo.image,
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(5)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///ユーザ名前＆コメント時間
                            Row(
                              children: [
                                ///ユーザ名前
                                Text(
                                  data.commentUserInfo.name ?? "",
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                ),
                                SizedBox(width: ScreenSize.fitPxWidth(5)),

                                ///コメント時間
                                Text(
                                  DateFormatUtilities().noYYYYMMDDformat(data.postTime),
                                  style: TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize12),
                                ),
                              ],
                            ),

                            ///コメント：メッセージ
                            SizedBox(
                              width: ScreenSize.width - ScreenSize.fitPxWidth(70),
                              child: Text(
                                data.message,
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ),

                            SizedBox(height: ScreenSize.fitPxWidth(5)),

                            Visibility(
                              visible: data.commentUserInfo.uid == userData.uid && !isEditStart,
                              child: Row(
                                children: [
                                  ///コメント編集ボタン
                                  GestureDetector(
                                    onTap: () {
                                      isEditStart = true;
                                      choicedCommentEditDataIndex = index;
                                      commentController.text =
                                          ref.read(postCommentListControllerProvider).listData[index].message;
                                      render();
                                    },
                                    child: Text(
                                      "編輯",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                    ),
                                  ),

                                  SizedBox(width: ScreenSize.fitPxWidth(5)),

                                  ///コメント削除ボタン
                                  GestureDetector(
                                    onTap: () {
                                      ///削除確認
                                      viewModel.postCommentDeleteCheck(
                                          data: data, dataIndex: index, postListController: postListController);
                                    },
                                    child: Text(
                                      "刪除",
                                      style: TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),

        ///コメント欄
        commentContainerBuild(ref),
      ],
    );
  }

  ///コメント欄
  Widget commentContainerBuild(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        Visibility(
          visible: isEditStart,
          child: Container(
            width: ScreenSize.width,
            height: ScreenSize.fitPxWidth(48),
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
            color: AppColors.black28.withOpacity(.8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "正在編輯訊息",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                  ),
                ),
                MainBtn(
                  onPress: () {
                    isEditStart = false;
                    commentController.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                    render();
                  },
                  child: Container(
                    padding: EdgeInsets.all(ScreenSize.fitPxWidth(10)),
                    decoration: BoxDecoration(
                        color: AppColors.greyColor57, borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(10))),
                    child: Icon(
                      FontAwesomeIcons.close,
                      color: AppColors.whiteColor,
                      size: ScreenSize.fontSize12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black37,
              border: Border(
                top: BorderSide(
                  color: AppColors.greyColor54,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fitPxWidth(12),
                vertical: ScreenSize.fitPxWidth(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: ScreenSize.fitPxHeight(10)),
                      UserIcon(
                        iconSize: ScreenSize.fitPxHeight(25),
                        image: userData.image,
                      ),
                      SizedBox(width: ScreenSize.fitPxHeight(10)),

                      /// コメント欄
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenSize.fitPxHeight(8),
                            vertical: ScreenSize.fitPxHeight(6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor57,
                            borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(13)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: BaseInputField(
                                  hintText: "留言",
                                  controller: commentController,
                                  autoFocus: autoFocusKeyBoard,
                                  maxLines: 3,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  HomeGlobalViewModel().needLoginCheckFunc(berforeCloseConfirmDialogFunc: () {
                                    closePage();
                                  }, func: () async {
                                    bool isSuccess = false;
                                    if (isEditStart) {
                                      ///編集
                                      isSuccess = await viewModel.postCommentUpdate(
                                          message: commentController.text, dataIndex: choicedCommentEditDataIndex);
                                    } else {
                                      /// 作成
                                      isSuccess = await viewModel.postCommentCreate(
                                        message: commentController.text,
                                        dataIndex: dataIndex,
                                        postListController: postListController,
                                      );
                                    }

                                    if (isSuccess) {
                                      isEditStart = false;
                                      commentController.text = "";
                                      // ignore: use_build_context_synchronously
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenSize.fitPxWidth(8), vertical: ScreenSize.fitPxWidth(3)),
                                  decoration: BoxDecoration(
                                    color: AppColors.orangeColor,
                                    borderRadius: BorderRadius.circular(
                                      ScreenSize.fitPxWidth(10),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.eco_sharp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(12)),

                      ///分享按鈕
                      GestureDetector(
                        onTap: () async {
                          await PostViewUtilities().sharePost(postId: ref.watch(choicedPostProvider).id);
                        },
                        child: PostViewUtilities().iconWithText(
                          iconData: FontAwesomeIcons.arrowUpRightFromSquare,
                          iconColor: AppColors.greyColor180A221,
                          text: "分享",
                          style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
