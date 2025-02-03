import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';

import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../global/user_login_status_controller.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';

import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/dialog/confirm_dialog.dart';

class PostCommentPage extends BaseBottomSheet {
  final StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController;
  final int dataIndex;

  PostCommentPage({required this.dataIndex, this.postListController});

  bool isEditStart = false;
  TextEditingController commentController = TextEditingController();
  int choicedCommentEditDataIndex = -1;

  @override
  double buildHeight() {
    return 0.5;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);

    render();
  }

  @override
  Widget build(ref) {
    ProfileData userData = ref.watch(loginUserData);
    return CommonScaffold(
      type: PageType.window,
      bgColor: AppColors.transparent,
      child: Column(
        children: [
          ///タイトル
          Text(
            "回覆",
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
          ),

          Expanded(
            child: APIListWidget(
                size: 7,
                isNeedToTopBtn: false,
                apiFunc: (page, size) {
                  int choicedPostProviderId = ref.read(choicedPostProvider).id;
                  return PostService().getPostCommentData(page, size, choicedPostProviderId);
                },
                listControllerProvider: postCommentListControllerProvider,
                noDataWidget: Center(
                  child: Text(
                    "目前沒有任何留言",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                  ),
                ),
                itemChild: (data, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: ScreenSize.fitPxWidth(15),
                      right: ScreenSize.fitPxWidth(15),
                      bottom: ScreenSize.fitPxWidth(10),
                    ),
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

          ///コメント欄
          commentContainerBuild(ref),
        ],
      ),
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
              border: Border(
                top: BorderSide(
                  color: AppColors.greyColor54,
                ),
              ),
            ),
            height: ScreenSize.fitPxHeight(70),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(12)),
              child: Column(
                children: [
                  SizedBox(height: ScreenSize.fitPxHeight(10)),
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
                                  autoFocus: true,
                                  onFieldSubmitted: (value) {
                                    viewModel.postCommentCreate(
                                      message: commentController.text,
                                      dataIndex: dataIndex,
                                      postListController: postListController,
                                    );
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
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
