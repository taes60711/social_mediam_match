import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/custom_service_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/pageManager/enum/bottom_bar_path.dart';
import '../../../provider/account/user_provider.dart';
import '../../utilities/style/app_colors.dart';

class PrivacySettingPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
          title: "設定",
        ),
        SizedBox(height: ScreenSize.fitPxHeight(15)),
        MainBtn(
          onPress: () {
            CustomServicePage().show(context);
          },
          child: _buildButtonContainer(iconData: Icons.question_answer, text: "問題回報"),
        ),
        MainBtn(
          onPress: () {
            ConfirmDilaog(
                title: "提示",
                content: "確定要登出？",
                conirmFunc: () async {
                  UserLoginStatusController().logOut();
                  closePage();
                  HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
                }).show(context);
          },
          child: _buildButtonContainer(
            iconData: FontAwesomeIcons.rightFromBracket,
            text: "登出",
            needEnterIcon: false,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContainer({
    required IconData iconData,
    required String text,
    bool needEnterIcon = true,
    bool needNotificationDot = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        border: Border(
          bottom: BorderSide(color: AppColors.greyColor98, width: 0.6),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fontSize24),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize16,
            ),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Expanded(
              child: Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: ScreenSize.fontSize16,
                    ),
                  ),
                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                  Visibility(
                    visible: needNotificationDot,
                    child: AppCommonTools().notificationDotWidget(
                      ref.watch(loginUserNotReadNotificationCount) <= 0,
                      notReadCount: ref.watch(loginUserNotReadNotificationCount),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: needEnterIcon,
              child: Icon(
                FontAwesomeIcons.chevronRight,
                size: ScreenSize.fontSize14,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
