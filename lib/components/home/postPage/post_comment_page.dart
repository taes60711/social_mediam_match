import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
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
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';

final postCommentListControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class PostCommentPage extends BaseBottomSheet {
  PostViewModel viewModel;

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
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxWidth(15),
                      vertical: ScreenSize.fitPxWidth(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            Row(
                              children: [
                                Text(
                                  data.commentUserInfo.name ?? "",
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                ),
                                SizedBox(width: ScreenSize.fitPxWidth(5)),
                                Text(
                                  data.postTime,
                                  style: TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize12),
                                ),
                              ],
                            ),
                            Text(
                              data.message,
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          downWidgetBuild(ref),
        ],
      ),
    );
  }

  Widget downWidgetBuild(WidgetRef ref) {
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
                    child: BaseInputField(
                      hintText: "留言",
                      controller: TextEditingController(),
                      autoFocus: true,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      PostModel c = ref.read(listControllerProvider).listData[0];
                      c.commentCount++;

                      ref.read(choicedPostProvider.notifier).state = PostModel().copyWith(data: c);
                      ref.read(listControllerProvider.notifier).editData(0, c);
                      print("object");
                      render();
                    },
                    child: Text("sad")),
                SizedBox(width: ScreenSize.fitPxWidth(12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
