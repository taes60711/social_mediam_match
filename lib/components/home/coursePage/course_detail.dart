import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../../models/course_model.dart';

class CourseDetail extends StatelessWidget {
  final CourseModel? courseData;
  const CourseDetail({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    Widget component = Container();

    if (courseData != null) {
      CourseModel realCourseData = courseData!;

      component = Container(
        width: ScreenSize().width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("課程標題:${realCourseData.title}"),
            Text("課程創建者${realCourseData.courseCreateduserInfo.email}"),
            Text("課程內容:${realCourseData.content}"),
            Text("課程難度:${realCourseData.needLevel}"),
            Text("課程類別:${realCourseData.type}"),
            Text("課程前需求:${realCourseData.beforeNeed}"),
            Text("最後更新日: ${realCourseData.postTime}"),
            Column(
              children: realCourseData.chapterList.map((e) {
                return ExpansionTile(
                  title: Text("章節 ${e.chapter}"),
                  children: [
                    Container(
                      width: ScreenSize().width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: e.content.map((e) {
                          Map<String, dynamic> resultData = jsonDecode(e);
                          String chapterText = "${resultData['text']}";
                          String chapterUrl = "${resultData['url']}";
                          return Row(
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
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }).toList(),
            )
          ],
        ),
      );
    }
    return component;
  }
}
