import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../utilities/custom_end_drawer.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/user_icon.dart';
import '../skillExChangePage/user_detail.dart';

class CourseDetail extends StatelessWidget {
  final CourseModel? courseData;
  final LoginUser? userData;
  final GlobalKey<ScaffoldState> globalKey;
  final VoidCallback gotoFriendPage;
  const CourseDetail({super.key, this.courseData, required this.globalKey, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    Widget component = Container();

    if (courseData != null) {
      CourseModel realCourseData = courseData!;

      Widget breakLine = Container(
        margin: const EdgeInsets.all(5),
        width: ScreenSize().width,
        height: 0.3,
        color: hintTextColor,
      );

      component = Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(height: 5),
            Text(
              realCourseData.title,
              style: TextStyle(fontSize: 19),
            ),
            Text(
              "課程類別: ${realCourseData.type}",
              style: TextStyle(fontSize: 12, color: hintTextColor),
            ),
            breakLine,
            Text(
              "課程前需求:",
              style: TextStyle(fontSize: 14),
            ),
            Container(
              width: ScreenSize().width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: hintTextColor.withAlpha(50),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(realCourseData.beforeNeed),
            ),
            breakLine,
            Text(
              "課程內容:",
              style: TextStyle(fontSize: 14),
            ),
            Container(
              width: ScreenSize().width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: hintTextColor.withAlpha(50),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(realCourseData.content),
            ),
            SizedBox(height: 5),
            Text(
              "學習技能:",
              style: TextStyle(fontSize: 14),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SkillListView(
                    skillList: realCourseData.courseLearningSkills,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "難度: ${realCourseData.needLevel}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            breakLine,
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
                  builder: (BuildContext context) {
                    return CustomEndDrawer(
                      child: Dismissible(
                        direction: DismissDirection.startToEnd,
                        resizeDuration: const Duration(milliseconds: 1),
                        onDismissed: (_) => Navigator.of(context).pop(),
                        key: const Key('key'),
                        child: UserDetail(
                          globalKey: globalKey,
                          userData: userData,
                          otherUser: realCourseData.courseCreateduserInfo,
                          gotoFriendPage: gotoFriendPage,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(color: googleColor.withAlpha(150), borderRadius: BorderRadius.circular(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "作成者 : ",
                          style: TextStyle(fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: UserIcon(
                            iconSize: 35,
                            image: realCourseData.courseCreateduserInfo.image,
                          ),
                        ),
                        Text(
                          "${realCourseData.courseCreateduserInfo.name != "" ? realCourseData.courseCreateduserInfo.name ?? "" : realCourseData.courseCreateduserInfo.email}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      "最終更新日 : ${realCourseData.postTime}",
                      style: TextStyle(color: normalBgColor2, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: realCourseData.chapterList.map((e) {
                return ExpansionTile(
                  title: Text("章節 ${e.chapter}"),
                  children: [
                    SizedBox(
                      width: ScreenSize().width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: e.content.map((e) {
                          Map<String, dynamic> resultData = jsonDecode(e);
                          String chapterText = "${resultData['text']}";
                          String chapterUrl = "${resultData['url']}";
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.ondemand_video,
                                    color: normalBgColor2,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      String vidoeHtml = "<iframe src='${chapterUrl}'></iframe>";

                                      showGeneralDialog(
                                          barrierColor: Colors.black.withOpacity(0.7),
                                          transitionBuilder: (context, a1, a2, widget) {
                                            return Transform.scale(
                                              scale: a1.value,
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: SizedBox(
                                                  height: ScreenSize().height,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          margin: const EdgeInsets.only(right: 20, bottom: 20),
                                                          height: 30,
                                                          width: 30,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: normalTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                      RichTextView(content: vidoeHtml)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          transitionDuration: Duration(milliseconds: 200),
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          context: context,
                                          pageBuilder: (context, animation1, animation2) {
                                            return Container();
                                          });
                                    },
                                    child: Text(
                                      chapterText,
                                      style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    }
    return BackgroundWidget(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: component,
      ),
    );
  }
}
