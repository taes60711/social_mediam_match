import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/userPage/my_notification_page/course/my_notification_course_manager_btm_sheet.dart';
import 'package:social_mediam_match/provider/course/course_provider.dart';

import '../../../../../enum/date_format_utilities.dart';
import '../../../../../models/course_model.dart';
import '../../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../../utilities/appBar/basic_top_bar.dart';

import '../../../../utilities/custom_expansion_title.dart';
import '../../../../utilities/endDrawers/base_end_drawer.dart';
import '../../../../utilities/main_button.dart';
import '../../../../utilities/rich_text_view.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/style/style_config.dart';
import '../../../../utilities/user_icon.dart';
import '../../../coursePage/course_utilites.dart';

class MyNotificationCourseDetailPage extends BaseEndDrawer {
  CourseModel data;

  MyNotificationCourseDetailPage({required this.data});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  @override
  Widget build(WidgetRef ref) {
    CourseModel choiceData = data;

    return Column(
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
          title: choiceData.title,
          rightWidget: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(choicedCourseProvider.notifier).update((e) => data);
                  MyNotificationCourseManagerBtmSheet().show(context);
                },
                child: Container(
                  width: 30,
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: Icon(
                    FontAwesomeIcons.ellipsis,
                    color: AppColors.greyColor130,
                    size: ScreenSize.fontSize16,
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
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
