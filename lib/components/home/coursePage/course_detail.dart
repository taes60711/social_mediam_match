import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/course_provider.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/appBar/basic_top_bar.dart';
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
                        "類別 ${choiceData.type}",
                        style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.greyColor176),
                      ),
                      const Expanded(child: SizedBox(width: 1)),

                      ///申請ボタン
                      Visibility(
                        visible: userData.uid != choiceData.createdBy && choiceData.signUpStatus == "none",
                        child: MainBtn(
                          title: "申請",
                          onPress: () {
                            ConfirmDilaog(
                              title: '提示',
                              content: '確定要申請？',
                              conirmFunc: () async {
                                bool isSucess =
                                    await CourseService().signUpCourse(courseId: choiceData.id, userUID: userData.uid);
                                if (isSucess) {
                                  choiceData.signUpStatus = "signing";
                                  ref.read(choicedCourseProvider.notifier).update((state) => choiceData);
                                  ref.read(courseListController.notifier).editData(dataIndex, choiceData);
                                  render();
                                }
                              },
                            ).show(context);
                          },
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
                          borderRadius: BorderRadius.circular(10),
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
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(5)),

                  Container(
                    width: ScreenSize.width,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor176.withAlpha(50),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      choiceData.content,
                      style: TextStyle(color: AppColors.whiteColor),
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
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(3)),
                        child: Text(
                          "難度 ${choiceData.needLevel}",
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor176.withAlpha(50),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      choiceData.beforeNeed,
                      style: TextStyle(color: AppColors.whiteColor),
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
                              "最終更新日 : ${choiceData.postTime}",
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
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      collapsedTrailingWidget: Icon(
                        Icons.keyboard_arrow_up,
                        color: AppColors.whiteColor,
                      ),
                      expandedTrailingWidget: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.whiteColor,
                      ),
                      children: <Widget>[
                        RichTextView(content: choiceData.prStory),
                      ],
                    ),
                  ),

                  ///チャプター
                  Column(
                    children: choiceData.chapterList.asMap().entries.map((e) {
                      int index = e.key;
                      CourseChapterInfo chapterInfo = e.value;
                      return CustomExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                          chapterInfo.chapterName == "" ? "chapter${index + 1}" : chapterInfo.chapterName,
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                        collapsedTrailingWidget: Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.whiteColor,
                        ),
                        expandedTrailingWidget: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.whiteColor,
                        ),
                        children: <Widget>[
                          SizedBox(
                            width: ScreenSize.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: choiceData.chapterList[index].content.map((e) {
                                String content = e;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: RichTextView(content: content),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
}
