import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/setting/block_user_page/block_user_page.dart';

import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/pageManager/enum/bottom_bar_path.dart';

import '../../../../provider/account/user_provider.dart';
import '../../../../provider/course/course_provider.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../utilities/style/app_colors.dart';
import '../../firendsPage/firends_page.dart';
import '../../skillExChangePage/skill_user_change_page.dart';
import '../../skillExChangePage/skill_user_change_page_by_skill_filter.dart';
import '../../skillExChangePage/skill_user_change_page_by_textfilter.dart';
import 'custom_service_page.dart';
import 'usage_terms_dialog.dart';

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
          title: "一般／設定",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 問題回報
                MainBtn(
                  onPress: () {
                    CustomServicePage().show(context);
                  },
                  child: _buildButtonContainer(iconData: Icons.question_answer, text: "問題回報"),
                ),

                /// 使用者條款
                MainBtn(
                  onPress: () {
                    UsageTermsDialog().show(context);
                  },
                  child: _buildButtonContainer(iconData: FontAwesomeIcons.fileShield, text: "使用者條款"),
                ),

                /// 黑名單
                MainBtn(
                  onPress: () {
                    BlockUserPage().show(context);
                  },
                  child: _buildButtonContainer(iconData: FontAwesomeIcons.userLock, text: "黑名單"),
                ),

                SizedBox(
                  height: ScreenSize.fitPxWidth(20),
                ),

                /// 刪除帳號
                MainBtn(
                  onPress: () {
                    ConfirmDilaog(
                        title: "警告",
                        content: "刪除帳號後, 資料將無法再回復\n\n確定要刪除該帳號？",
                        conirmFunc: () async {
                          await UserLoginStatusController().deleteAccount();
                          logoutAllFunc();
                        }).show(context);
                  },
                  child: _buildButtonContainer(
                    iconData: FontAwesomeIcons.userSlash,
                    text: "刪除帳號",
                    needEnterIcon: false,
                  ),
                ),

                /// 登出
                MainBtn(
                  onPress: () {
                    ConfirmDilaog(
                      title: "提示",
                      content: "確定要登出？",
                      conirmFunc: () async {
                        await UserLoginStatusController().logOut();
                        logoutAllFunc();
                      },
                    ).show(context);
                  },
                  child: _buildButtonContainer(
                    iconData: FontAwesomeIcons.rightFromBracket,
                    text: "登出",
                    needEnterIcon: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void logoutAllFunc() {
    closePage();

    ref.invalidate(listControllerProvider);
    ref.invalidate(newlistControllerProvider);
    ref.invalidate(typelistControllerProvider);

    ref.invalidate(userExChangelistControllerProvider);
    ref.invalidate(userExChangeTextFilteredlistControllerProvider);
    ref.invalidate(userExChangeSkillFilterlistControllerProvider);

    ref.invalidate(courseMainPageListPorver);
    ref.invalidate(courseByTextFilterListPorver);
    ref.invalidate(courseByTextFilterListPorver);

    ref.invalidate(frinedListProvider);

    HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
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
