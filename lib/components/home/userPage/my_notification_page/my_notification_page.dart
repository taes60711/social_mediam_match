// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/my_notification_page/course/my_notification_course_page.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/user_profile_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/dialog/await_confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../../enum/date_format_utilities.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../services/notification_service.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/style/app_colors.dart';
import 'my_notification_post_page.dart';

final notificationListControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class MyNotificationPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
          title: "通知",
        ),
        SizedBox(height: ScreenSize.fitPxWidth(16)),
        Expanded(
          child: APIListWidget(
              apiFunc: (page, size) {
                return NotificationService().requestNotificationList(page, size, userUId: userData.uid);
              },
              listControllerProvider: notificationListControllerProvider,
              size: 20,
              noDataWidget: SizedBox(
                width: ScreenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0, bottom: 10),
                      child: Icon(
                        Icons.notifications,
                        color: AppColors.whiteColor,
                        size: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "沒有通知",
                        style: TextStyle(
                          color: AppColors.greyColor98,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              itemChild: (data, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20)),
                  child: SizedBox(
                    width: ScreenSize.width,
                    child: Dismissible(
                      key: const Key(""),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (v) async {
                        bool isConfirm = await awaitConfirmDialog(context, title: "提示", content: "確定要刪除這則通知？");
                        if (isConfirm) {
                          await notificationDelete(data, index);
                        }
                        return isConfirm;
                      },
                      background: Container(
                        color: AppColors.redColor,
                        child: Padding(
                          padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                FontAwesomeIcons.trash,
                                color: AppColors.whiteColor,
                                size: ScreenSize.fontSize18,
                              ),
                              SizedBox(
                                width: ScreenSize.fitPxWidth(5),
                              ),
                              Text(
                                "刪除",
                                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: MainBtn(
                        onPress: () async {
                          if (data.type == 0) {
                            MyNotificationPostPage(postId: "${data.postId}").show(context);
                          } else if (data.type == 1) {
                            MyNotificationCourseDetailPage(courseId: "${data.courseId}").show(context);
                          } else if (data.type == 2) {
                            ProfileData otherUserData = data.sendNotificationuserInfo;
                            UserProfileAllInfoBottomSheet(userData: otherUserData).show(context);
                          }
                          await notificationRead(data, index);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(3)),
                              child: Icon(
                                numberTypeIcon(data.type),
                                size: ScreenSize.fontSize20,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      UserIcon(
                                        iconSize: ScreenSize.fitPxWidth(30),
                                        image: data.sendNotificationuserInfo.image,
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                                      Expanded(
                                        child: Text(
                                          data.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, color: AppColors.greyColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                                  Text(
                                    DateFormatUtilities().format(data.postTime.toString()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !data.isRead,
                              child: Text(
                                "未讀",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        filterSearchBtn(),
      ],
    );
  }

  Widget filterSearchBtn() {
    return Container(
      height: ScreenSize.fitPxHeight(80),
      color: AppColors.black37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(15)),
              child: MainBtn(
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
                  margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(40)),
                  onPress: () async {
                    if (ref.read(loginUserNotReadNotificationCount.notifier).state <= 0) {
                      return;
                    }

                    await NotificationService().updateReadNotificationCount(userUid: ref.watch(loginUserData).uid);
                    for (int i = 0; i < ref.read(notificationListControllerProvider).listData.length; i++) {
                      NotificationModel updateData = ref.read(notificationListControllerProvider).listData[i];
                      updateData.isRead = true;
                      ref.read(notificationListControllerProvider.notifier).editData(i, updateData);
                    }
                    ref.read(loginUserNotReadNotificationCount.notifier).update((e) => 0);

                    render();
                  },
                  title: "全部已讀"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> notificationDelete(NotificationModel data, int index) async {
    await NotificationService().deleteNotification(id: data.id);
    if (!data.isRead) {
      int notReadCount = ref.read(loginUserNotReadNotificationCount.notifier).state;
      notReadCount--;
      ref.read(loginUserNotReadNotificationCount.notifier).update((e) => notReadCount);
    }

    render();
  }

  Future<void> notificationRead(NotificationModel data, int index) async {
    NotificationModel updateData = data;
    if (!updateData.isRead) {
      updateData.isRead = !updateData.isRead;
      await NotificationService().updateReadNotificationCount(id: data.id);
      ref.read(notificationListControllerProvider.notifier).editData(index, updateData);
      int notReadCount = ref.read(loginUserNotReadNotificationCount.notifier).state;
      notReadCount--;
      ref.read(loginUserNotReadNotificationCount.notifier).update((e) => notReadCount);

      render();
    }
  }

  IconData numberTypeIcon(int num) {
    switch (num) {
      /// 文章
      case 0:
        return FontAwesomeIcons.fileSignature;

      ///コース
      case 1:
        return FontAwesomeIcons.bookOpenReader;

      ///フレンド
      case 2:
        return FontAwesomeIcons.solidUser;
      default:
        return FontAwesomeIcons.a;
    }
  }
}
