import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/skill_list_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/states/course_state.dart';

import '../../../models/user_model.dart';

class CoursePage extends StatelessWidget {
  final LoginUser userData;
  const CoursePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    List<CourseModel> courseData = context.watch<CourseState>().courseData;

    bool isFirstLoading = context.select((CourseState value) => value.isFirstLoading);
    bool isAddDataLoading = context.select((CourseState value) => value.isAddDataLoading);
    bool isReLoading = context.select((CourseState value) => value.isReLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((CourseState value) => value.globalKey);
    CourseModel? choicedCourse = context.select((CourseState value) => value.choicedCourse);

    return Scaffold(
      key: globalKey,
      endDrawer: CourseDetail(
        courseData: choicedCourse,
      ),
      body: SafeArea(
        child: StatefulWrapper(
          onInit: () {
            courseState.getAllCourseData(searchType: "First");
          },
          child: isFirstLoading
              ? const Loading()
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.dehaze_rounded),
                      ),
                    ),
                    isReLoading ? const Loading() : Container(),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            final scrollPosition = scrollNotification.metrics.pixels;
                            final max = scrollNotification.metrics.maxScrollExtent;
                            if (!isAddDataLoading && !isReLoading) {
                              if (scrollPosition > max && !isAddDataLoading) {
                                courseState.addData();
                              } else if (scrollPosition < 0 && !isReLoading) {
                                courseState.reLoadingPage();
                              }
                            }
                          }
                          if (scrollNotification is ScrollEndNotification) {
                            if (isAddDataLoading) {
                              courseState.getAllCourseData(searchType: "AddData");
                            } else if (isReLoading) {
                              courseState.getAllCourseData(searchType: "Reload");
                            }
                          }
                          return true;
                        },
                        child: ListView.builder(
                            itemCount: courseData.length,
                            itemBuilder: (context, index) {
                              Widget mainBody = Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    inspect(courseData[index]);
                                    courseState.choicedPage(courseData[index]);
                                    globalKey.currentState!.openEndDrawer();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    color: Colors.transparent,
                                    width: ScreenSize().width,
                                    height: 265,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration:
                                                    BoxDecoration(color: googleColor, borderRadius: BorderRadius.circular(3)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      courseData[index].title,
                                                      style: const TextStyle(fontSize: 16),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: SkillListView(
                                                            skillList: courseData[index].courseLearningSkills,
                                                            fontSize: 10,
                                                            backgroundColor: normalBgColor2.withAlpha(150),
                                                          ),
                                                        ),
                                                        Text(
                                                          "難度: ${courseData[index].needLevel}",
                                                          style: TextStyle(fontSize: 12, color: normalTextColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                height: 0.3,
                                                width: ScreenSize().width,
                                                color: hintTextColor,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "課程大綱: ",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    Text(
                                                      "${courseData[index].content}",
                                                      style: TextStyle(fontSize: 13),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "課程前需要: ",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    Text(
                                                      "${courseData[index].beforeNeed}",
                                                      style: TextStyle(color: hintTextColor, fontSize: 12),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                          height: 0.3,
                                          width: ScreenSize().width,
                                          color: hintTextColor,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "作成者:",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        child: UserIcon(
                                                          iconSize: 25,
                                                          image: courseData[index].courseCreateduserInfo.image,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${courseData[index].courseCreateduserInfo.name != "" ? courseData[index].courseCreateduserInfo.name ?? "" : courseData[index].courseCreateduserInfo.email}",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "最終更新日:${courseData[index].postTime}",
                                                    style: TextStyle(fontSize: 11, color: hintTextColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: GestureDetector(
                                                child: Icon(
                                                  FontAwesomeIcons.ellipsis,
                                                  color: hintTextColor,
                                                  size: 14,
                                                ),
                                                onTap: () {
                                                  print("Icon");
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          height: 0.3,
                                          width: ScreenSize().width,
                                          color: hintTextColor,
                                        ),
                                        // Text("公開有否: ${courseData[index].isPublic}"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              return index != courseData.length - 1
                                  ? mainBody
                                  : Column(
                                      children: [
                                        mainBody,
                                        isAddDataLoading ? Loading() : Container(),
                                      ],
                                    );
                            }),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
