import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';

import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../../services/post_service.dart';

import '../../utilities/apiListView/api_list_view.dart';

class PostCommentPage extends BaseBottomSheet {
  PostViewModel viewModel;
  bool isEditStart = false;
  PostCommentPage({required this.viewModel});
  @override
  double buildHeight() {
    return 0.5;
  }

  @override
  Widget build(ref) {
    return CommonScaffold(
      type: PageType.window,
      bgColor: Colors.transparent,
      child: Column(
        children: [
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
                    style: TextStyle(color: AppColors.whiteColor),
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
                        Padding(
                          padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(3)),
                          child: UserIcon(
                            iconSize: 30,
                            image: data.commentUserInfo.image,
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
                                  data.postTime,
                                  style: TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize12),
                                ),
                              ],
                            ),

                            ///コメント：メッセージ/テキストフィールド
                            commentEditBuild(ref, data),

                            SizedBox(height: ScreenSize.fitPxWidth(5)),
                            Row(
                              children: [
                                ///ユーザ名前
                                GestureDetector(
                                  onTap: () {
                                    data.isEditor = !data.isEditor;
                                    isEditStart = true;
                                    render();
                                  },
                                  child: Text(
                                    "編輯",
                                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                  ),
                                ),

                                SizedBox(width: ScreenSize.fitPxWidth(5)),

                                ///コメント時間
                                Text(
                                  "刪除",
                                  style: TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),

          ///コメント欄
          commentCntainerBuild(
            ref,
          ),
        ],
      ),
    );
  }

  ///コメント：メッセージ/テキストフィールド
  Widget commentEditBuild(WidgetRef ref, PostCommentTextEditorModel data) {
    return data.isEditor
        ? Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxWidth(8),
              vertical: ScreenSize.fitPxWidth(5),
            ),
            width: ScreenSize.width - ScreenSize.fitPxWidth(70),
            decoration: BoxDecoration(
              color: AppColors.greyColor57,
              borderRadius: BorderRadius.circular(
                ScreenSize.fitPxWidth(8),
              ),
            ),
            child: BaseInputField(
              controller: data.textEditingController,
              autoFocus: true,
              onFocusChanged: (va) async {
                if (isEditStart) {
                  await Future.delayed(Duration.zero);
                  isEditStart = false;
                } else {
                  data.isEditor = !data.isEditor;
                  if (data.message != data.textEditingController.text) {
                    data.message = data.textEditingController.text;
                  }
                  render();
                }
              },
            ),
          )
        : Text(
            data.message,
            style: TextStyle(color: AppColors.whiteColor),
          );
  }

  Widget commentCntainerBuild(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Container(
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
                SizedBox(width: ScreenSize.fitPxHeight(10)),
                UserIcon(
                  iconSize: ScreenSize.fitPxHeight(25),
                  image: userData.image,
                ),
                SizedBox(width: ScreenSize.fitPxHeight(10)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxHeight(10),
                      vertical: ScreenSize.fitPxHeight(5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor57,
                      borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: BaseInputField(
                            hintText: "留言",
                            controller: TextEditingController(),
                            autoFocus: true,
                          ),
                        ),
                        MainBtn(
                            onPress: () {
                              ProfileData userData = ref.watch(loginUserData);
                              PostCommentTextEditorModel sdsat = PostCommentTextEditorModel(
                                uid: 63,
                                postId: 30,
                                userUid: "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2",
                                message: "qwewqwe",
                                postTime: "2024-06-30T09:14:38.000+00:00",
                                commentUserInfo: userData,
                                isEditor: false,
                                textEditingController: TextEditingController(),
                              );

                              ref.read(postCommentListControllerProvider.notifier).addDataTofirst(sdsat);

                              PostModel c = ref.read(listControllerProvider).listData[0];
                              c.commentCount++;

                              ref.read(choicedPostProvider.notifier).state = PostModel().copyWith(data: c);
                              ref.read(listControllerProvider.notifier).editData(0, c);
                              print("object");
                              render();
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8), vertical: ScreenSize.fitPxWidth(2)),
                              decoration: BoxDecoration(
                                  color: AppColors.orangeColor, borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(10))),
                              child: Icon(
                                Icons.chair,
                                color: AppColors.whiteColor,
                              ),
                            )),
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
    );
  }
}
