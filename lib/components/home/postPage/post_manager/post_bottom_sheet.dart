import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import '../../../../global/home_global_view_model.dart';
import '../../../../models/post_model.dart';
import '../../../utilities/BottomSheets/base_bottom_sheet.dart';

/// 文章編集のページ
class PostBtmSheet extends BaseBottomSheet {
  PostModel choicedData;
  PostBtmSheet({required this.choicedData});

  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        managerPageMainBtn(
          iconData: FontAwesomeIcons.arrowUpRightFromSquare,
          text: "分享",
          onPress: () async {
            await PostViewUtilities().sharePost(postId: choicedData.id);
          },
        ),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        managerPageMainBtn(
          iconData: FontAwesomeIcons.userLock,
          text: "封鎖用戶",
          onPress: () async {
            HomeGlobalViewModel().blockUser(userData: choicedData.postUserInfo);
          },
        ),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
      ],
    );
  }

  Widget managerPageMainBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
          vertical: ScreenSize.fitPxWidth(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor54,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize14,
            ),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
