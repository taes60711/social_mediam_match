import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/home/userPage/myCourse/added_courses_page.dart';
import 'package:social_mediam_match/components/home/userPage/myCourse/courese_member_manager.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/states/course_state.dart';

import '../../../../enum/skill_end_drawer_type.dart';
import '../../../../models/course_model.dart';
import '../../../../models/user_model.dart';
import '../../../../pageManager/enum/route_path.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../account/skill_bar.dart';
import '../../../utilities/endDrawers/custom_end_drawer.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import '../../../utilities/user_icon.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    LoginUser userData = context.watch<UserProvider>().userData;
    List<CourseModel> myCourseData = context.watch<CourseState>().myCourseData;
    GlobalKey<ScaffoldState> globalKey = context.select((CourseState value) => value.globalKey);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: ScreenSize.width * 0.33,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                SizedBox(width: ScreenSize.width * 0.33, child: const Center(child: Text("我的課程"))),
              ],
            ),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      appBar: TabBar(
                        tabs: const [
                          SizedBox(
                            height: 25,
                            child: Tab(text: '已加入的課程'),
                          ),
                          SizedBox(
                            height: 25,
                            child: Tab(text: '創建的課程'),
                          ),
                        ],
                        isScrollable: true,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 1.0, color: normalBgColor),
                          insets: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        labelPadding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                        labelColor: normalBgColor2,
                      ),
                      body: TabBarView(
                        children: [
                          ChangeNotifierProvider(
                            create: (_) => CourseState(),
                            child: AddedCoursesPage(
                              userData: userData,
                            ),
                          ),
                          StatefulWrapper(
                            onInit: () {
                              Future.delayed(const Duration(milliseconds: 400)).then((value) {
                                courseState.getCourseDataByUserId(userId: userData.uid, searchType: "First");
                              });
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: myCourseData.length,
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
                                                          courseData: myCourseData[index],
                                                          gotoFriendPage: () {},
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
                                              width: ScreenSize.width,
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
                                                          decoration: BoxDecoration(
                                                              color: googleColor, borderRadius: BorderRadius.circular(3)),
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
                                                                    child: skillBar(
                                                                      SkillEndDrawerType.close,
                                                                      backGroundColor: normalBgColor2.withAlpha(150),
                                                                      courseSkillData: myCourseData[index].courseLearningSkills,
                                                                      fontSize: 10,
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
                                                          width: ScreenSize.width,
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
                                                    width: ScreenSize.width,
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
                                                                                    width: ScreenSize.width * 0.33,
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.topCenter,
                                                                                    width: ScreenSize.width * 0.33,
                                                                                    child: Icon(
                                                                                      Icons.remove,
                                                                                      size: 35,
                                                                                      color: normalBgColor2,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.topRight,
                                                                                    padding: const EdgeInsets.only(right: 10),
                                                                                    width: ScreenSize.width * 0.33,
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
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                    top: 10, right: 10, left: 10),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.of(context).pushNamed(
                                                                                        RoutePath.courseEditPage.value,
                                                                                        arguments: {
                                                                                          "userData": userData,
                                                                                          "courseData": myCourseData[index],
                                                                                        });
                                                                                  },
                                                                                  child: Container(
                                                                                    width: ScreenSize.width,
                                                                                    height: 45,
                                                                                    decoration: BoxDecoration(
                                                                                        color: normalBgColor2,
                                                                                        borderRadius: BorderRadius.circular(10)),
                                                                                    child: Center(
                                                                                      child: SizedBox(
                                                                                        width: 100,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.edit,
                                                                                              color: normalTextColor,
                                                                                              size: 25,
                                                                                            ),
                                                                                            const SizedBox(width: 5),
                                                                                            SizedBox(
                                                                                              width: 70,
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  "編輯",
                                                                                                  style: TextStyle(
                                                                                                      color: normalTextColor),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                    top: 10, right: 10, left: 10),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                    void showMemberManagerPage() {
                                                                                      showDialog<void>(
                                                                                          barrierColor: barrierColor,
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return ChangeNotifierProvider(
                                                                                              create: (_) => CourseState(),
                                                                                              child: CourseMemberManager(
                                                                                                courseId: myCourseData[index].id,
                                                                                              ),
                                                                                            );
                                                                                          });
                                                                                    }

                                                                                    showMemberManagerPage();
                                                                                  },
                                                                                  child: Container(
                                                                                    width: ScreenSize.width,
                                                                                    height: 45,
                                                                                    decoration: BoxDecoration(
                                                                                        color: normalBgColor2,
                                                                                        borderRadius: BorderRadius.circular(10)),
                                                                                    child: Center(
                                                                                      child: SizedBox(
                                                                                        width: 100,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.edit,
                                                                                              color: normalTextColor,
                                                                                              size: 25,
                                                                                            ),
                                                                                            const SizedBox(width: 5),
                                                                                            SizedBox(
                                                                                              width: 70,
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  "管理成員",
                                                                                                  style: TextStyle(
                                                                                                      color: normalTextColor),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
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
                                                    width: ScreenSize.width,
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
                            ),
                          ),
                        ],
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
