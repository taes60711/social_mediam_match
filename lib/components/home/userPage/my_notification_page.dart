import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/services/course_service.dart';
import 'package:social_mediam_match/services/post_service.dart';

import '../../../models/notification_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';

import '../../../pagemanager/setting/route_controller.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/corse_view_model.dart';
import '../../../provider/post/post_view_model.dart';

import '../../../services/notification_service.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/endDrawers/course_detail_end_drawer.dart';
import '../../utilities/endDrawers/post_comment_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class MyNotificationPage extends StatelessWidget {
  const MyNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Stack(
        children: [
          mainBody(context),
          courseDetailEndDrawer(),
          postDetailEndDrawer(),
          userDetailEndDrawer(),
        ],
      ),
    );
  }
}

Widget mainBody(BuildContext context) {
  LoginUser userData = context.watch<UserProvider>().userData;

  return Column(
    children: [
      BaseTopBar(
        title: "通知",
        rightWidget: GestureDetector(
          onTap: () {
            List<NotificationModel> notificationList =
                context.read<BaseAPIListProvider<NotificationModel>>().listData;
            for (int index = 0; index < notificationList.length; index++) {
              notificationList[index].isRead = true;
              context.read<BaseAPIListProvider<NotificationModel>>().editData(
                    dataIndex: index,
                    updatedData: notificationList[index],
                  );
            }
            context.read<UserProvider>().updateNotificationCount(allRead: true);
            NotificationService().updateReadNotificationCount(userUid: userData.uid);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: normalBgColor2,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: const Text(
              "全部已讀",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      Expanded(
        child: Builder(
          builder: (context) {
            return APIListView<NotificationModel>(
              providerList: context.watch<BaseAPIListProvider<NotificationModel>>().listData,
              apiFunc: (int page, int size) {
                return NotificationService()
                    .requestNotificationList(page, size, userUId: userData.uid);
              },
              itemChild: (List<NotificationModel> data, int index) {
                NotificationModel notificationData = data[index];

                return Dismissible(
                  key: const Key(""),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    print("delete notificationData id ${notificationData.id}");
                    notificationData.isRead = true;
                    context
                        .read<BaseAPIListProvider<NotificationModel>>()
                        .editData(dataIndex: index, updatedData: notificationData);
                    context
                        .read<BaseAPIListProvider<NotificationModel>>()
                        .deleteData(choiceData: notificationData);
                    NotificationService().deleteNotification(id: notificationData.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: ScreenSize.width,
                    child: GestureDetector(
                      onTap: () async {
                        if (notificationData.type == 0) {
                          PostModel choicedPost = await PostService()
                              .getPostDataByPostId(notificationData.postId ?? -1);

                          PostViewModel(postContext: context)
                              .postDetailInit(choicedPost: choicedPost);
                        } else if (notificationData.type == 1) {
                          LoginUser userData = context.read<UserProvider>().userData;
                          CourseModel openedCourse = await CourseService()
                              .getCourseBycourseId(userData.uid, notificationData.courseId ?? -1);
                          CourseViewModel(courseContext: context)
                              .courseDetailInit(openedCourse: openedCourse);
                        } else if (notificationData.type == 2) {
                          openUserDetailEndDrawer(
                              context: context,
                              otherUserData: notificationData.sendNotificationuserInfo);
                        }
                        if (!notificationData.isRead) {
                          notificationData.isRead = true;
                          context
                              .read<BaseAPIListProvider<NotificationModel>>()
                              .editData(dataIndex: index, updatedData: notificationData);
                          context.read<UserProvider>().updateNotificationCount();
                          NotificationService()
                              .updateReadNotificationCount(id: notificationData.id);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(bottom: 3),
                        margin: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: normalBgColor2,
                              ),
                              child: Center(
                                child: Icon(
                                  numberTypeIcon(notificationData.type),
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            ///アイコン
                            GestureDetector(
                              onTap: () {
                                openUserDetailEndDrawer(
                                    context: context,
                                    otherUserData: notificationData.sendNotificationuserInfo);
                              },
                              child: UserIcon(
                                iconSize: 35,
                                image: notificationData.sendNotificationuserInfo.image,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notificationData.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${notificationData.postTime}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !notificationData.isRead,
                              child: const Text(
                                "未讀",
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loadingBuilder: () {
                return const Loading();
              },
            );
          },
        ),
      ),
      const SizedBox(height: 50),
    ],
  );
}

void addFriendCheck(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("是否將對方加為好友?"),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: TextBtn(
                          title: tr("cancel"),
                          titleColor: normalBgColor2,
                          btnColor: normalTextColor,
                          onPress: () async {
                            RouteOptions.pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextBtn(
                          title: tr("confirm"),
                          titleColor: normalTextColor,
                          btnColor: normalBgColor,
                          onPress: () async {
                            RouteOptions.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      );
    },
  );
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
