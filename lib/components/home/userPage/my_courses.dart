import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/states/course_state.dart';

import '../../../global.dart';
import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
    List<CourseModel> myCourseData = context.watch<CourseState>().myCourseData;
    return StatefulWrapper(
        onInit: () {
          courseState.getCourseDataByUserId(userId: userData.uid, searchType: "First");
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: ScreenSize().width * 0.33,
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    SizedBox(width: ScreenSize().width * 0.33, child: const Center(child: Text("我的課程"))),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: myCourseData.length,
                        itemBuilder: (BuildContext context, index) {
                          Widget mainBody = Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                inspect(myCourseData[index]);
                                Navigator.of(context).pushNamed(RoutePath.courseEditPage.value, arguments: {
                                  "userData": userData,
                                  "courseData": myCourseData[index],
                                });
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
                                            decoration: BoxDecoration(color: googleColor, borderRadius: BorderRadius.circular(3)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myCourseData[index].title,
                                                  style: const TextStyle(fontSize: 16),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: SkillListView(
                                                        skillList: myCourseData[index].courseLearningSkills,
                                                        fontSize: 10,
                                                        backgroundColor: normalBgColor2.withAlpha(150),
                                                      ),
                                                    ),
                                                    Text(
                                                      "難度: ${myCourseData[index].needLevel}",
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
                                                  "${myCourseData[index].content}",
                                                  style: TextStyle(fontSize: 13),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "課程前需要: ",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  "${myCourseData[index].beforeNeed}",
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
                                                  user: myCourseData[index].courseCreateduserInfo);
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
                                                          image: myCourseData[index].courseCreateduserInfo.image,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${myCourseData[index].courseCreateduserInfo.name != "" ? myCourseData[index].courseCreateduserInfo.name ?? "" : myCourseData[index].courseCreateduserInfo.email}",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "最終更新日:${myCourseData[index].postTime}",
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
                                    // Text("公開有否: ${courseData[index].isPublic}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                          return mainBody;
                        }))
              ],
            ),
          ),
        ));
  }
}
