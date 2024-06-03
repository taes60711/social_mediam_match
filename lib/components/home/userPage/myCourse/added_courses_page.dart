import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';

import '../../../../models/course_model.dart';
import '../../../../models/user_model.dart';
import '../../../../states/course_state.dart';
import '../../../utilities/custom_end_drawer.dart';
import '../../../utilities/skill_list_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import '../../../utilities/user_icon.dart';
import '../../coursePage/course_detail.dart';

class AddedCoursesPage extends StatelessWidget {
  final LoginUser userData;
  const AddedCoursesPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    List<CourseModel> myAddedCourseData = context.watch<CourseState>().myAddedCourseData;
    GlobalKey<ScaffoldState> globalKey = context.select((CourseState value) => value.globalKey);
    Widget component = Container();
    if (myAddedCourseData.isNotEmpty) {
      component = Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: myAddedCourseData.length,
                itemBuilder: (BuildContext context, index) {
                  Widget mainBody = Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        print("courseOpen");
                        showDialog(
                          context: context,
                          useSafeArea: false,
                          barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
                          builder: (BuildContext context) {
                            return CustomEndDrawer(
                              child: Dismissible(
                                direction: DismissDirection.startToEnd,
                                resizeDuration: const Duration(milliseconds: 1),
                                onDismissed: (_) => Navigator.of(context).pop(),
                                key: const Key('key'),
                                child: ChangeNotifierProvider(
                                  create: (_) => CourseState(),
                                  child: CourseDetail(
                                    globalKey: globalKey,
                                    userData: userData,
                                    courseData: myAddedCourseData[index],
                                    gotoFriendPage: () {},
                                    bIsAdded: true,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
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
                                          myAddedCourseData[index].title,
                                          style: const TextStyle(fontSize: 16),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: SkillListView(
                                                skillList: myAddedCourseData[index].courseLearningSkills,
                                                fontSize: 10,
                                                backgroundColor: normalBgColor2.withAlpha(150),
                                              ),
                                            ),
                                            Text(
                                              "難度: ${myAddedCourseData[index].needLevel}",
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
                                          "${myAddedCourseData[index].content}",
                                          style: TextStyle(fontSize: 13),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "課程前需要: ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "${myAddedCourseData[index].beforeNeed}",
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
                                          user: myAddedCourseData[index].courseCreateduserInfo);
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
                                                  image: myAddedCourseData[index].courseCreateduserInfo.image,
                                                ),
                                              ),
                                              Text(
                                                "${myAddedCourseData[index].courseCreateduserInfo.name != "" ? myAddedCourseData[index].courseCreateduserInfo.name ?? "" : myAddedCourseData[index].courseCreateduserInfo.email}",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "最終更新日:${myAddedCourseData[index].postTime}",
                                            style: TextStyle(fontSize: 11, color: hintTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
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
                  return mainBody;
                }),
          )
        ],
      );
    }

    return StatefulWrapper(
      onInit: () {
        courseState.getAddedCourses(userId: userData.uid, searchType: "First");
      },
      child: Scaffold(
        body: SafeArea(child: component),
      ),
    );
  }
}
