// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/utilities/background_widget.dart';
// import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
// import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
// import 'package:social_mediam_match/models/course_model.dart';
// import 'package:social_mediam_match/services/course_service.dart';
// import 'package:social_mediam_match/services/post_service.dart';

// import '../../../models/notification_model.dart';
// import '../../../models/post_model.dart';
// import '../../../models/user_model.dart';

// import '../../../pagemanager/setting/route_controller.dart';
// import '../../../provider/account/user_provider.dart';
// import '../../../provider/corse_view_model.dart';
// import '../../../provider/post/post_view_model.dart';

// import '../../../services/notification_service.dart';
// import '../../utilities/apiListView/api_list_view.dart';
// import '../../utilities/apiListView/base_api_list_provider.dart';
// import '../../utilities/custom_button.dart';
// import '../../utilities/endDrawers/course_detail_end_drawer.dart';
// import '../../utilities/endDrawers/post_comment_end_drawer.dart';
// import '../../utilities/endDrawers/user_detail_end_drawer.dart';
// import '../../utilities/loading.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/user_icon.dart';

// class MyNotificationPage extends StatelessWidget {
//   const MyNotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BackgroundWidget(
//       child: Stack(
//         children: [
//           mainBody(context),
//           // courseDetailEndDrawer(),
//           // postDetailEndDrawer(),
//           userDetailEndDrawer(),
//         ],
//       ),
//     );
//   }
// }

// Widget mainBody(BuildContext context) {
//   ProfileData userData = context.watch<UserProvider>().userData;

//   return Column(
//     children: [
//       BaseTopBar(
//         title: "通知",
//         rightWidget: GestureDetector(
//           onTap: () {
//             List<NotificationModel> notificationList = context.read<BaseAPIListProvider<NotificationModel>>().listData;
//             for (int index = 0; index < notificationList.length; index++) {
//               notificationList[index].isRead = true;
//               context.read<BaseAPIListProvider<NotificationModel>>().editData(
//                     dataIndex: index,
//                     updatedData: notificationList[index],
//                   );
//             }
//             context.read<UserProvider>().updateNotificationCount(allRead: true);
//             NotificationService().updateReadNotificationCount(userUid: userData.uid);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: normalBgColor2,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             child: const Text(
//               "全部已讀",
//               style: TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//           ),
//         ),
//       ),
//       Expanded(
//         child: Builder(
//           builder: (context) {
//             return APIListView<NotificationModel>(
//               providerList: context.watch<BaseAPIListProvider<NotificationModel>>().listData,
//               apiFunc: (int page, int size) {
//                 return NotificationService().requestNotificationList(page, size, userUId: userData.uid);
//               },
//               itemChild: (List<NotificationModel> data, int index) {
//                 NotificationModel notificationData = data[index];

//                 return Dismissible(
//                   key: const Key(""),
//                   direction: DismissDirection.endToStart,
//                   onDismissed: (_) {
//                     print("delete notificationData id ${notificationData.id}");
//                     notificationData.isRead = true;
//                     context
//                         .read<BaseAPIListProvider<NotificationModel>>()
//                         .editData(dataIndex: index, updatedData: notificationData);
//                     context.read<BaseAPIListProvider<NotificationModel>>().deleteData(choiceData: notificationData);
//                     NotificationService().deleteNotification(id: notificationData.id);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     width: ScreenSize.width,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (notificationData.type == 0) {
//                           PostModel choicedPost = await PostService().getPostDataByPostId(notificationData.postId ?? -1);

//                           // PostViewModel(context: context).postDetailInit(choicedPost: choicedPost);
//                         } else if (notificationData.type == 1) {
//                           ProfileData userData = context.read<UserProvider>().userData;
//                           CourseModel openedCourse =
//                               await CourseService().getCourseBycourseId(userData.uid, notificationData.courseId ?? -1);
//                           // CourseViewModel(courseContext: context).courseDetailInit(openedCourse: openedCourse);
//                         } else if (notificationData.type == 2) {
//                           openUserDetailEndDrawer(context: context, otherUserData: notificationData.sendNotificationuserInfo);
//                         }
//                         if (!notificationData.isRead) {
//                           notificationData.isRead = true;
//                           context
//                               .read<BaseAPIListProvider<NotificationModel>>()
//                               .editData(dataIndex: index, updatedData: notificationData);
//                           context.read<UserProvider>().updateNotificationCount();
//                           NotificationService().updateReadNotificationCount(id: notificationData.id);
//                         }
//                       },
//                       child: Container(
//                         color: Colors.transparent,
//                         padding: const EdgeInsets.only(bottom: 3),
//                         margin: const EdgeInsets.only(bottom: 3),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 24,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: normalBgColor2,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   numberTypeIcon(notificationData.type),
//                                   size: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),

//                             ///アイコン
//                             GestureDetector(
//                               onTap: () {
//                                 openUserDetailEndDrawer(
//                                     context: context, otherUserData: notificationData.sendNotificationuserInfo);
//                               },
//                               child: UserIcon(
//                                 iconSize: 35,
//                                 image: notificationData.sendNotificationuserInfo.image,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     notificationData.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     "${notificationData.postTime}",
//                                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Visibility(
//                               visible: !notificationData.isRead,
//                               child: const Text(
//                                 "未讀",
//                                 style: TextStyle(fontSize: 10, color: Colors.grey),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               loadingBuilder: () {
//                 return const Loading();
//               },
//             );
//           },
//         ),
//       ),
//       const SizedBox(height: 50),
//     ],
//   );
// }

// void addFriendCheck(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               margin: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   const Text("是否將對方加為好友?"),
//                   const SizedBox(height: 50),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextBtn(
//                           title: tr("cancel"),
//                           titleColor: normalBgColor2,
//                           btnColor: normalTextColor,
//                           onPress: () async {
//                             RouteOptions.pop();
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: TextBtn(
//                           title: tr("confirm"),
//                           titleColor: normalTextColor,
//                           btnColor: normalBgColor,
//                           onPress: () async {
//                             RouteOptions.pop();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//         ],
//       );
//     },
//   );
// }

// IconData numberTypeIcon(int num) {
//   switch (num) {
//     /// 文章
//     case 0:
//       return FontAwesomeIcons.fileSignature;

//     ///コース
//     case 1:
//       return FontAwesomeIcons.bookOpenReader;

//     ///フレンド
//     case 2:
//       return FontAwesomeIcons.solidUser;
//     default:
//       return FontAwesomeIcons.a;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/my_notification_page/course/my_notification_course_page.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/user_profile_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../../enum/date_format_utilities.dart';
import '../../../../models/course_model.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/post_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../services/course_service.dart';
import '../../../../services/notification_service.dart';
import '../../../../services/post_service.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
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
          rightWidget: MainBtn(
            onPress: () async {
              if (ref.read(loginUserNotReadNotificationCount.notifier).state <= 0) {
                return;
              }

              // await NotificationService().updateReadNotificationCount(userUid: userData.uid);
              for (int i = 0; i < ref.read(notificationListControllerProvider).listData.length; i++) {
                NotificationModel updateData = ref.read(notificationListControllerProvider).listData[i];
                updateData.isRead = !updateData.isRead;
                ref.read(notificationListControllerProvider.notifier).editData(i, updateData);
              }
              ref.read(loginUserNotReadNotificationCount.notifier).update((e) => 0);

              render();
            },
            title: "全部已讀",
          ),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(16)),
        Expanded(
          child: APIListWidget(
              apiFunc: (page, size) {
                return NotificationService().requestNotificationList(page, size, userUId: userData.uid);
              },
              listControllerProvider: notificationListControllerProvider,
              itemChild: (data, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20)),
                  child: SizedBox(
                    width: ScreenSize.width,
                    child: MainBtn(
                      onPress: () async {
                        if (data.type == 0) {
                          PostModel choicedPost = await PostService().getPostDataByPostId(data.postId ?? -1);
                          MyNotificationPostPage(data: choicedPost).show(context);
                        } else if (data.type == 1) {
                          CourseModel openedCourse = await CourseService().getCourseBycourseId(userData.uid, data.courseId ?? -1);
                          MyNotificationCourseDetailPage(data: openedCourse).show(context);
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
                              color: Colors.white,
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
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenSize.fitPxWidth(5)),
                                Text(
                                  DateFormatUtilities().format(data.postTime.toString()),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !data.isRead,
                            child: const Text(
                              "未讀",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Future<void> notificationRead(NotificationModel data, int index) async {
    NotificationModel updateData = data;
    if (!updateData.isRead) {
      updateData.isRead = !updateData.isRead;
      // await NotificationService().updateReadNotificationCount(id: data.id);
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
