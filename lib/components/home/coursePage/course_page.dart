import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
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
                    isReLoading ? Loading() : Container(),
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
                            physics: BouncingScrollPhysics(),
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
                                            Text(courseData[index].title),
                                            Row(
                                              children: [
                                                UserIcon(
                                                  iconSize: 60,
                                                  image: courseData[index].courseCreateduserInfo.image,
                                                ),
                                                Text(courseData[index].courseCreateduserInfo.email)
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                courseData[index].content,
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
                                                Text(courseData[index].title),
                                                Row(
                                                  children: [
                                                    UserIcon(
                                                      iconSize: 60,
                                                      image: courseData[index].courseCreateduserInfo.image,
                                                    ),
                                                    Text(courseData[index].courseCreateduserInfo.email)
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    courseData[index].content,
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
