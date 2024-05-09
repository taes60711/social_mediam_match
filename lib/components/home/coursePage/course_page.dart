import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
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
                              return index != courseData.length - 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: courseData[index].type == 1 ? Colors.indigoAccent : Colors.lime,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                UserIcon(
                                                  iconSize: 60,
                                                  image: courseData[index].courseCreateduserInfo.image,
                                                ),
                                                Text(courseData[index].courseCreateduserInfo.email)
                                              ],
                                            ),
                                            Text(courseData[index].title),
                                            Text("最後更新日期(Time): ${courseData[index].postTime}"),
                                            Text("課程難度(int): ${courseData[index].needLevel}"),
                                            Text("學習的技能(List): ${courseData[index].courseLearningSkills}"),
                                            Text("Tag技能(List): ${courseData[index].courseTagsSkillList}"),
                                            Text("學習前需要(String): ${courseData[index].beforeNeed}"),
                                            Text("公開有否(Bool): ${courseData[index].isPublic}"),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "課程大綱(String): ${courseData[index].content}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  inspect(courseData[index]);
                                                  courseState.choicedPage(courseData[index]);
                                                  globalKey.currentState!.openEndDrawer();
                                                },
                                                child: Text("觀看詳細")),
                                            Text(courseData[index].postTime),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            color: courseData[index].type == 1 ? Colors.indigoAccent : Colors.lime,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    UserIcon(
                                                      iconSize: 60,
                                                      image: courseData[index].courseCreateduserInfo.image,
                                                    ),
                                                    Text(courseData[index].courseCreateduserInfo.email)
                                                  ],
                                                ),
                                                Text(courseData[index].title),
                                                Text("最後更新日期(Time): ${courseData[index].postTime}"),
                                                Text("課程難度(int): ${courseData[index].needLevel}"),
                                                Text("學習的技能(List): ${courseData[index].courseLearningSkills}"),
                                                Text("Tag技能(List): ${courseData[index].courseTagsSkillList}"),
                                                Text("學習前需要(String): ${courseData[index].beforeNeed}"),
                                                Text("公開有否(Bool): ${courseData[index].isPublic}"),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "課程大綱(String): ${courseData[index].content}",
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      inspect(courseData[index]);
                                                      courseState.choicedPage(courseData[index]);
                                                      globalKey.currentState!.openEndDrawer();
                                                    },
                                                    child: Text("觀看詳細")),
                                                Text(courseData[index].postTime),
                                              ],
                                            ),
                                          ),
                                        ),
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
