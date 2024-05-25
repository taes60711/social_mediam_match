import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/home/coursePage/course_filter.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/skill_list_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/states/course_state.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../postPage/post_body.dart';
import '../skillExChangePage/user_detail.dart';

class CoursePage extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;

  const CoursePage({
    super.key,
    required this.userData,
    required this.gotoFriendPage,
  });

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    List<CourseModel> courseData = context.watch<CourseState>().courseData;

    bool isFirstLoading = context.select((CourseState value) => value.isFirstLoading);
    bool isAddDataLoading = context.select((CourseState value) => value.isAddDataLoading);
    bool isReLoading = context.select((CourseState value) => value.isReLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((CourseState value) => value.globalKey);
    CourseModel? choicedCourse = context.select((CourseState value) => value.choicedCourse);
    String endDrawerType = context.select((CourseState value) => value.endDrawerType);
    LoginUser? otherUser = context.select((CourseState value) => value.otherUser);

    double startScrollPosition = context.select((CourseState value) => value.startScrollPosition);
    ScrollController scrollController = ScrollController();
    bool floatButtonIsVisiable = context.select((CourseState value) => value.floatButtonIsVisiable);

    Widget endDrawerWidget;
    if (endDrawerType == "userDetail") {
      endDrawerWidget = UserDetail(
        globalKey: globalKey,
        userData: userData,
        otherUser: otherUser,
        gotoFriendPage: gotoFriendPage,
      );
    } else if (endDrawerType == "courseFilter") {
      endDrawerWidget = CourseFilter(
        globalKey: globalKey,
        userData: userData,
      );
    } else {
      endDrawerWidget = CourseDetail(
        courseData: choicedCourse,
        globalKey: globalKey,
        userData: userData,
        gotoFriendPage: gotoFriendPage,
      );
    }
    return BackgroundWidget(
      child: StatefulWrapper(
        onInit: () async {
          await courseState.getAllCourseData(searchType: "First");
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: globalKey,
          endDrawer: endDrawerWidget,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RoutePath.courseEditPage.value, arguments: {
                    "userData": userData,
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: normalTextColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1,
                        offset: Offset(-1, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.penToSquare,
                    size: 16,
                    color: Color.fromARGB(255, 247, 147, 100),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: floatButtonIsVisiable,
                child: GestureDetector(
                  onTap: () {
                    scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: normalBgColor2,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1,
                          offset: Offset(-1, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: const Icon(
                      FontAwesomeIcons.angleUp,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      courseState.openEndDrawer("courseFilter");
                      globalKey.currentState!.openEndDrawer();
                    },
                    icon: const Icon(Icons.dehaze_rounded),
                  ),
                ),
                isFirstLoading
                    ? const Expanded(child: PostLoading())
                    : Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollNotification) {
                            if (scrollNotification is ScrollStartNotification) {
                              courseState.getStartScrollPos(scrollNotification.metrics.pixels);
                            } else if (scrollNotification is ScrollUpdateNotification) {
                              final scrollPosition = scrollNotification.metrics.pixels;
                              final max = scrollNotification.metrics.maxScrollExtent;
                              if (!isAddDataLoading && !isReLoading) {
                                if (scrollPosition > max && !isAddDataLoading) {
                                  courseState.addData();
                                } else if (startScrollPosition <= 0) {
                                  if (scrollPosition < 0 && !isReLoading) {
                                    courseState.reLoadingPage();
                                  }
                                }
                                courseState.floatButtonVisiableChange(scrollPosition);
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
                              controller: scrollController,
                              itemCount: courseData.length,
                              itemBuilder: (context, index) {
                                Widget mainBody = Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      inspect(courseData[index]);
                                      courseState.openEndDrawer("course", course: courseData[index]);
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
                                                child: GestureDetector(
                                                  onTap: () {
                                                    courseState.openEndDrawer("userDetail",
                                                        user: courseData[index].courseCreateduserInfo);
                                                    globalKey.currentState!.openEndDrawer();
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
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
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    color: Colors.transparent,
                                                    child: Icon(
                                                      FontAwesomeIcons.ellipsis,
                                                      color: hintTextColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    print("Icon");
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        backgroundColor: Colors.transparent,
                                                        builder: (builder) {
                                                          return DraggableScrollableSheet(
                                                              expand: false,
                                                              minChildSize: 0.25,
                                                              initialChildSize: 0.3,
                                                              maxChildSize: 0.3,
                                                              builder: (context, scrollController) {
                                                                return Container(
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.vertical(
                                                                      top: Radius.circular(10),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: ScreenSize().width * 0.33,
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.topCenter,
                                                                            width: ScreenSize().width * 0.33,
                                                                            child: Icon(
                                                                              Icons.remove,
                                                                              size: 35,
                                                                              color: normalBgColor2,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.topRight,
                                                                            padding: const EdgeInsets.only(right: 10),
                                                                            width: ScreenSize().width * 0.33,
                                                                            child: Container(
                                                                              color: Colors.transparent,
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.close,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        });
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
      ),
    );
  }
}
