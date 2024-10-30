import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/base_overlay_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import 'post_main_page.dart';

final postCommentListControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class PostCommentPage extends BaseOverlayBottomSheet {
  @override
  Widget build(ref) {
    return Column(
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
        )
      ],
    );
  }

  @override
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
      height: ScreenSize.fitPxHeight(50),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(12)),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.fitPxHeight(5),
            ),
            Row(
              children: [
                UserIcon(
                  iconSize: ScreenSize.fitPxHeight(25),
                  image: userData.image,
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
