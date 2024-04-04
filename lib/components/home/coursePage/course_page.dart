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
    List<CourseModel> topCourseData = context.watch<CourseState>().topCourseData;
    bool isFirstLoading = context.select((CourseState value) => value.isFirstLoading);
    bool isTopFirstLoading = context.select((CourseState value) => value.isTopFirstLoading);
    int carouselPageIndex = context.select((CourseState value) => value.carouselPageIndex);
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
            courseState.getCourseData(0, isFirstSearch: true);
            courseState.getCourseData(1, isFirstSearch: true);
          },
          child: isFirstLoading || isTopFirstLoading
              ? const Loading()
              : Column(
                  children: [
                    Container(
                      width: ScreenSize().width,
                      child: Stack(
                        children: [
                          CarouselSlider(
                            items: topCourseData
                                .map(
                                  (e) => Builder(builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        int index = topCourseData.indexWhere((element) => element == e);
                                        print(index);
                                        courseState.choicedPage(topCourseData[index]);
                                        globalKey.currentState!.openEndDrawer();
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(color: Colors.amber),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("課程主題 : ${e.title}"),
                                            Text(
                                              "課程內容 : ${e.content}",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text("創建者 : ${e.courseCreateduserInfo.email}")
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                )
                                .toList(),
                            options: CarouselOptions(
                              height: 130,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                courseState.carouselPageOnchange(index);
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: topCourseData.map((e) {
                                int index = topCourseData.indexWhere((element) => element == e);
                                return Container(
                                  margin: EdgeInsets.only(right: 5, bottom: 5),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: index == carouselPageIndex
                                        ? Color.fromARGB(255, 132, 166, 240)
                                        : Color.fromARGB(255, 50, 106, 228),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: courseData.length,
                          itemBuilder: (context, index) {
                            return Padding(
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
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
