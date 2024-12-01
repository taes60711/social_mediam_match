import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/about_page.dart';
import 'package:social_mediam_match/components/home/userPage/my_notification_page/my_notification_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/pageManager/enum/bottom_bar_path.dart';

import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/firebase_notification_service.dart';
import '../../utilities/style/style_config.dart';
import '../firendsPage/my_friends.dart';

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
          title: "一般",
        ),
        SizedBox(height: ScreenSize.fitPxHeight(15)),
        MainBtn(
          onPress: () {
            AboutPage().show(context);
          },
          child: _buildButtonContainer(iconData: FontAwesomeIcons.splotch, text: "關於"),
        ),
        MainBtn(
          onPress: () {
            MyNotificationPage().show(context);
          },
          child: _buildButtonContainer(iconData: Icons.notifications, text: "通知", needNotificationDot: true),
        ),
        MainBtn(
          onPress: () {
            MyFriendPage().show(context);
          },
          child: _buildButtonContainer(iconData: FontAwesomeIcons.userGroup, text: "好友管理"),
        ),
        MainBtn(
          onPress: () {
            ConfirmDilaog(
                title: "提示",
                content: "確定要登出？",
                conirmFunc: () {
                  UserLoginStatusController().logOut();
                  HomeGlobalViewModel().changeMainPage(BottomBarPath.home);
                  closePage();
                }).show(context);
          },
          child: _buildButtonContainer(
            iconData: FontAwesomeIcons.rightFromBracket,
            text: "登出",
            needEnterIcon: false,
          ),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(50)),
        MainBtn(
          onPress: () {
            String message = '"12135"對文章"1"按讚';
            NotificationModel notification = NotificationModel(
              id: -1,
              userUid: 'tzLaMcP3V9XOAMOcD0FAY5Nf4tE2',
              otherUserUid: 'ACqYscxtd2VSdPlkv1G8OgSTKxd2',
              type: 0,
              title: message,
              isRead: false,
              message: '',
              postId: 1,
              postTime: DateTime.now(),
              sendNotificationuserInfo: ProfileData(),
            );
            FirebaseNotificationService().sendNotification(
              message: message,
              sendto: ref.read(loginUserData.notifier).state.token ?? "",
              notifiactionInfo: notification,
            );
          },
          title: "send Post Good Notification",
        ),
        SizedBox(height: ScreenSize.fitPxWidth(20)),
        MainBtn(
          onPress: () {
            String message = '"555"將你加為好友';
            NotificationModel notification = NotificationModel(
              id: -1,
              userUid: ref.read(loginUserData.notifier).state.uid,
              otherUserUid: 'kTmSC7QNzoc1pf2jWd4sFOAr6q02',
              type: 3,
              title: message,
              roomId: 19,
              isRead: false,
              message: '',
              postTime: DateTime.now(),
              sendNotificationuserInfo: ProfileData(),
            );
            FirebaseNotificationService().sendNotification(
              message: message,
              sendto: ref.read(loginUserData.notifier).state.token ?? "",
              notifiactionInfo: notification,
            );
          },
          title: "send AddFriend Notification",
        ),
        SizedBox(height: ScreenSize.fitPxWidth(20)),
        MainBtn(
          onPress: () {
            String message = '"20240324@gmail.com"申請想要觀看課程"123456"';
            NotificationModel notification = NotificationModel(
              id: -1,
              userUid: ref.read(loginUserData.notifier).state.uid,
              otherUserUid: 'Fx0NZUwhLGNuDhaz1ZdyT2vyq3z1',
              type: 1,
              title: message,
              isRead: false,
              message: '',
              courseId: 19,
              postTime: DateTime.now(),
              sendNotificationuserInfo: ProfileData(),
            );
            FirebaseNotificationService().sendNotification(
              message: message,
              sendto: ref.read(loginUserData.notifier).state.token ?? "",
              notifiactionInfo: notification,
            );
          },
          title: "send CourseSignUp Notification",
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
                      ref.watch(loginUserNotReadNotificationCount) != 0,
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
