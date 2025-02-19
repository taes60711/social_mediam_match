import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/my_notification_page/course/my_notification_course_manager_btm_sheet.dart';
import 'package:social_mediam_match/components/utilities/api_page.dart';
import '../../../../../enum/date_format_utilities.dart';
import '../../../../../models/course_model.dart';
import '../../../../../provider/account/user_provider.dart';
import '../../../../../services/course_service.dart';
import '../../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../../utilities/appBar/basic_top_bar.dart';

import '../../../../utilities/app_common_tools.dart';
import '../../../../utilities/custom_expansion_title.dart';
import '../../../../utilities/endDrawers/base_end_drawer.dart';
import '../../../../utilities/main_button.dart';
import '../../../../utilities/rich_text_view.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/style/app_colors.dart';
import '../../../../utilities/user_icon.dart';
import '../../../coursePage/course_utilites.dart';

class MyNotificationCourseDetailPage extends BaseEndDrawer {
  String courseId;

  MyNotificationCourseDetailPage({required this.courseId});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(WidgetRef ref) {
    return APIPage<CourseModel>(
      apiFunc: () async {
        return await CourseService().getCourseBycourseId(ref.read(loginUserData).uid, int.parse(courseId));
      },
      child: (CourseModel data) {
        return Column(
          children: [
            BaseTopBar(
              backFunc: () {
                closePage();
              },
              title: data.title,
              rightWidget: Row(
                children: [
                  AppCommonTools().levelSetsumeiBtn(context),

                  ///シャアボタン
                  MainBtn(
                    onPress: () async {
                      MyNotificationCourseManagerBtmSheet(data: data).show(context);
                    },
                    child: Container(
                      height: ScreenSize.fitPxWidth(30),
                      width: ScreenSize.fitPxWidth(30),
                      color: AppColors.transparent,
                      child: Icon(
                        FontAwesomeIcons.ellipsis,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ユーザデータ
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
              child: MainBtn(
                onPress: () {
                  ///ユーザー詳細ページに遷移
                  UserProfileAllInfoBottomSheet(userData: data.courseCreateduserInfo).show(context);
                },
                child: Row(
                  children: [
                    UserIcon(
                      iconSize: ScreenSize.fitPxWidth(30),
                      image: data.courseCreateduserInfo.image,
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.courseCreateduserInfo.name ?? "",
                          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                        ),
                        Text(
                          "最終更新日 : ${DateFormatUtilities().format(data.postTime)}",
                          style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(8)),

            /// Tabバー　＆　ページ内容
            Expanded(
              child: Column(
                children: [
                  /// Tabバー
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(5)),
                    child: Row(
                      children: [
                        _buildTabBtn(context, tabText: "概要", index: 0),
                        _buildTabBtn(context, tabText: "章節", index: 1),
                      ],
                    ),
                  ),

                  /// ページ内容
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
                      child: PageView(
                        controller: pageController,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          SingleChildScrollView(child: mainBody(data)),
                          SingleChildScrollView(child: chapterPage(data)),
                        ],
                        onPageChanged: (value) {
                          pageIndex = value;
                          render();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      nodataWidget: Column(
        children: [
          ///タイトルバー
          BaseTopBar(
            backFunc: () => closePage(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
                  child: Icon(
                    FontAwesomeIcons.commentSlash,
                    size: 50,
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(10)),
                Text(
                  "沒有文章",
                  style: TextStyle(
                    fontSize: ScreenSize.fontSize20,
                    color: AppColors.greyColor130,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainBody(CourseModel data) {
    return Column(
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
              "類別 : ${CourseUtilites().formattedTag(data.type)}",
              style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.greyColor176),
            ),
          ],
        ),
        SizedBox(height: ScreenSize.fitPxHeight(8)),

        ///勉強するスキルバー
        Wrap(
          children: data.courseLearningSkills.map((e) {
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
            data.content,
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
                "程度 ${data.needLevel}",
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
        Visibility(
          visible: data.beforeNeed != "",
          child: Container(
            width: ScreenSize.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.greyColor176.withAlpha(50),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              data.beforeNeed,
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(10)),

        ///詳細内容
        Visibility(
          visible: data.prStory != "",
          child: CustomExpansionTile(
            initiallyExpanded: data.signUpStatus != "added",
            title: Text(
              "詳細內容",
              style: TextStyle(color: AppColors.whiteColor),
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
              RichTextView(content: data.prStory),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        Container(
          width: ScreenSize.width,
          color: AppColors.transparent,
          alignment: Alignment.centerRight,
          child: MainBtn(
            onPress: () {
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
              );
            },
            child: Text(
              "章節內容 >>",
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
            ),
          ),
        ),
      ],
    );
  }

  Widget chapterPage(CourseModel data) {
    return Column(
      children: data.chapterList.asMap().entries.map((e) {
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
                children: data.chapterList[index].content.map((e) {
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
    );
  }

  Widget _buildTabBtn(BuildContext context, {required String tabText, required int index}) {
    return MainBtn(
      onPress: () async {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      },
      child: Container(
        width: ScreenSize.width / 2,
        height: ScreenSize.fitPxHeight(30),
        alignment: Alignment.center,
        color: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabText,
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
            ),
            Visibility(
              visible: pageIndex == index,
              child: Container(
                width: ScreenSize.fitPxWidth(15),
                height: ScreenSize.fitPxWidth(1),
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
