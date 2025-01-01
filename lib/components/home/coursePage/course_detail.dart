import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_utilites.dart';

import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/services/course_service.dart';
import 'package:social_mediam_match/services/user_service.dart';

import '../../../enum/date_format_utilities.dart';
import '../../../models/course_model.dart';
import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/course/course_provider.dart';
import '../../../services/firebase_notification_service.dart';
import '../../../services/notification_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/appBar/basic_top_bar.dart';
import '../../utilities/app_common_tools.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/custom_expansion_title.dart';
import '../../utilities/main_button.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class CourseDetailPage extends BaseEndDrawer {
  int dataIndex;
  CourseModel data;
  StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController;
  CourseDetailPage({required this.courseListController, required this.data, required this.dataIndex});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  String notifaicationToken = "";

  @override
  Future<void> initState(WidgetRef ref) async {
    notifaicationToken =
        await UserService().requestUserNotificationTokenByUID(ref.read(choicedCourseProvider).courseCreateduserInfo.uid);
  }

  @override
  Widget build(WidgetRef ref) {
    CourseModel choiceData = ref.read(choicedCourseProvider);
    ProfileData userData = ref.read(loginUserData);
    return Column(
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
          title: choiceData.title,
          rightWidget: Row(
            children: [
              AppCommonTools().levelSetsumeiBtn(context),

              ///シャアボタン
              MainBtn(
                onPress: () async {
                  await CourseUtilites().shareCourse(courseId: data.id);
                },
                child: Container(
                  height: ScreenSize.fitPxWidth(30),
                  width: ScreenSize.fitPxWidth(30),
                  color: Colors.transparent,
                  child: Icon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: AppColors.whiteColor,
                    size: ScreenSize.fontSize20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///タグ
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.tag,
                        color: AppColors.whiteColor.withOpacity(.6),
                        size: ScreenSize.fontSize16,
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Text(
                        "類別 : ${CourseUtilites().formattedTag(choiceData.type)}",
                        style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.greyColor176),
                      ),
                      const Expanded(child: SizedBox(width: 1)),

                      ///申請ボタン
                      Visibility(
                        /// added signing none
                        visible:
                            userData.uid != choiceData.createdBy && choiceData.signUpStatus == "none" && !choiceData.isPublic,
                        child: Row(
                          children: [
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            MainBtn(
                              title: "申請",
                              onPress: () {
                                signUpCourse(choiceData: choiceData, userData: userData);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(8)),

                  ///勉強するスキルバー
                  Wrap(
                    children: choiceData.courseLearningSkills.map((e) {
                      return Container(
                        margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3), bottom: ScreenSize.fitPxWidth(8)),
                        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(100)),
                          color: AppColors.greyColor98,
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(5)),

                  ///内容
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.book,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize14,
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Text(
                        "大綱",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(5)),

                  Container(
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.fitPxHeight(5),
                      horizontal: ScreenSize.fitPxHeight(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor176.withAlpha(50),
                      borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(5)),
                    ),
                    child: Text(
                      choiceData.content,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(8)),

                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.wrench,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize14,
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Text(
                        "前置需求",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize14,
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(3)),
                        child: Text(
                          "程度 ${choiceData.needLevel}",
                          style: TextStyle(
                            color: AppColors.greyColor130,
                            fontSize: ScreenSize.fontSize12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(5)),

                  ///勉強前必要な知識
                  Container(
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.fitPxHeight(5),
                      horizontal: ScreenSize.fitPxHeight(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor176.withAlpha(50),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      choiceData.beforeNeed,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(10)),

                  /// ユーザデータ
                  MainBtn(
                    onPress: () {
                      ///ユーザー詳細ページに遷移
                      UserProfileAllInfoBottomSheet(userData: choiceData.courseCreateduserInfo).show(context);
                    },
                    child: Row(
                      children: [
                        UserIcon(
                          iconSize: ScreenSize.fitPxWidth(30),
                          image: choiceData.courseCreateduserInfo.image,
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(5)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              choiceData.courseCreateduserInfo.name ?? "",
                              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                            ),
                            Text(
                              "最終更新日 : ${DateFormatUtilities().format(choiceData.postTime)}",
                              style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: ScreenSize.fitPxHeight(10)),

                  ///詳細内容
                  Visibility(
                    visible: choiceData.prStory != "",
                    child: CustomExpansionTile(
                      initiallyExpanded: choiceData.signUpStatus != "added",
                      title: Text(
                        "詳細內容",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize16,
                        ),
                      ),
                      collapsedTrailingWidget: Icon(
                        Icons.keyboard_arrow_up,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize22,
                      ),
                      expandedTrailingWidget: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize22,
                      ),
                      children: <Widget>[
                        RichTextView(content: choiceData.prStory),
                      ],
                    ),
                  ),

                  ///チャプター
                  Builder(
                    builder: (context) {
                      bool isVisible = true;

                      /// added signing none
                      if (!choiceData.isPublic && choiceData.signUpStatus != "added" && userData.uid != choiceData.createdBy) {
                        isVisible = false;
                      }

                      return isVisible
                          ? Column(
                              children: choiceData.chapterList.asMap().entries.map((e) {
                                int index = e.key;
                                CourseChapterInfo chapterInfo = e.value;
                                return CustomExpansionTile(
                                  initiallyExpanded: true,
                                  title: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.book,
                                        color: Colors.white,
                                        size: ScreenSize.fontSize14,
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                                      Expanded(
                                        child: Text(
                                          chapterInfo.chapterName == "" ? "chapter${index + 1}" : chapterInfo.chapterName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: ScreenSize.fontSize16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  collapsedTrailingWidget: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: AppColors.whiteColor,
                                    size: ScreenSize.fontSize22,
                                  ),
                                  expandedTrailingWidget: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.whiteColor,
                                    size: ScreenSize.fontSize22,
                                  ),
                                  children: <Widget>[
                                    SizedBox(
                                      width: ScreenSize.width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: choiceData.chapterList[index].content.map((e) {
                                          String content = e;

                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(5)),
                                            child: Column(
                                              children: [
                                                SizedBox(height: ScreenSize.fitPxWidth(10)),
                                                RichTextView(content: content),
                                                SizedBox(height: ScreenSize.fitPxWidth(10)),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          : Container(
                              width: ScreenSize.width,
                              margin: EdgeInsets.only(top: ScreenSize.fitPxWidth(20)),
                              padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                              decoration: BoxDecoration(
                                color: AppColors.black37,
                                borderRadius: BorderRadius.circular(
                                  ScreenSize.fitPxWidth(8),
                                ),
                              ),
                              child: signUpStatus(choiceData),
                            );
                    },
                  ),

                  SizedBox(height: ScreenSize.fitPxHeight(20))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpStatus(CourseModel choiceData) {
    ProfileData userData = ref.read(loginUserData);
    if (choiceData.signUpStatus == "none") {
      return Column(
        children: [
          Text(
            "還有更多內容, 請按“申請”按鈕\n等待作者審核通過後即可觀看",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: ScreenSize.fontSize14,
            ),
          ),

          SizedBox(height: ScreenSize.fitPxWidth(8)),

          ///申請ボタン
          MainBtn(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(50), vertical: ScreenSize.fitPxWidth(10)),
            title: "申請",
            onPress: () {
              signUpCourse(choiceData: choiceData, userData: userData);
            },
          ),
        ],
      );
    } else if (choiceData.signUpStatus == "signing") {
      return Text(
        "正在等待對方審核中",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: ScreenSize.fontSize14,
        ),
      );
    }
    return Container();
  }

  void signUpCourse({required CourseModel choiceData, required ProfileData userData}) {
    ConfirmDilaog(
      title: '提示',
      content: '確定要申請？',
      conirmFunc: () async {
        bool isSucess = await CourseService().signUpCourse(courseId: choiceData.id, userUID: userData.uid);
        if (isSucess) {
          choiceData.signUpStatus = "signing";
          ref.read(choicedCourseProvider.notifier).update((state) => choiceData);
          ref.read(courseListController.notifier).editData(dataIndex, choiceData);

          String message = '"${choiceData.courseCreateduserInfo.name}"申請想要觀看課程"${choiceData.title}"';
          NotificationModel notification = NotificationModel.empty();
          notification.userUid = ref.read(loginUserData.notifier).state.uid;
          notification.otherUserUid = choiceData.courseCreateduserInfo.uid;
          notification.type = 1;
          notification.title = message;
          notification.courseId = choiceData.id;
          notification.sendNotificationuserInfo = ref.read(loginUserData.notifier).state;

          NotificationService().createNotification(notification: notification);

          if (notifaicationToken != "") {
            FirebaseNotificationService().sendNotification(
              message: message,
              sendto: notifaicationToken,
              notifiactionInfo: notification,
            );
          }

          render();
        }
      },
    ).show(context);
  }
}
