import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/corse_view_model.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../../../global.dart';
import '../../../pagemanager/enum/route_path.dart';
import '../../../pagemanager/setting/route_controller.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/home/skill_change_view_model.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/endDrawers/course_detail_end_drawer.dart';
import '../../utilities/endDrawers/course_filter_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/user_icon.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () async {
        courseContext = context;
        await SkillChangeViewModel(context: context).init();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Stack(
          children: [
            _mainBuild(context),
            courseDetailEndDrawer(),
            userDetailEndDrawer(),
            courseFilterEndDrawer(),
          ],
        ),
      ),
    );
  }
}

Widget _mainBuild(BuildContext context) {
  return Column(
    children: [
      BaseTopBar(
        leftWidget: Container(),
        rightWidget: GestureDetector(
          onTap: () {
            openCourseFilterEndDrawer(context: context);
          },
          child: const Icon(FontAwesomeIcons.sliders),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: APIListView<CourseModel>(
            size: 6,
            apiFunc: (int page, int size) {
              LoginUser userData = context.read<UserProvider>().userData;
              return CourseService().getAllCourses(userData.uid, page, size);
            },
            listType: ListType.grid,
            providerList: context.watch<BaseAPIListProvider<CourseModel>>().listData,
            customFloatbutton: GestureDetector(
              onTap: () {
                RouteOptions.pushTo(RoutePath.courseEditPage, arguments: {
                  "courseData": null,
                  "context": context,
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: normalBgColor,
                ),
              ),
            ),
            itemChild: (List<CourseModel> data, int index) {
              return GestureDetector(
                onTap: () {
                  CourseViewModel(courseContext: context).courseDetailInit(openedCourse: data[index]);
                },
                child: Container(
                  height: 260,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// title
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Text(
                                data[index].title,
                                style: TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "類別: 前端",
                                  style: TextStyle(fontSize: 12, color: normalBgColor2),
                                ),
                                Text(
                                  "難度: ${data[index].needLevel}",
                                  style: TextStyle(fontSize: 12, color: normalBgColor2),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: data[index].courseLearningSkills.map((e) {
                                    return Container(
                                      decoration: BoxDecoration(color: normalBgColor2, borderRadius: BorderRadius.circular(5)),
                                      margin: const EdgeInsets.only(right: 2),
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      child: Text(
                                        e,
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "課程大綱: ",
                              style: TextStyle(fontSize: 14, color: normalBgColor2),
                            ),
                            SizedBox(
                              height: 45,
                              child: Text(
                                data[index].content,
                                style: TextStyle(fontSize: 13, color: hintTextColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "課程前需要: ",
                              style: TextStyle(fontSize: 14, color: normalBgColor2),
                            ),
                            SizedBox(
                              height: 25,
                              child: Text(
                                data[index].beforeNeed,
                                style: TextStyle(color: hintTextColor, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 0.3,
                        width: ScreenSize.width,
                        color: hintTextColor,
                      ),
                      const Expanded(child: SizedBox(height: 1)),
                      GestureDetector(
                        onTap: () {
                          openUserDetailEndDrawer(context: context, otherUserData: data[index].courseCreateduserInfo);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "作成者:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: UserIcon(
                                      iconSize: 25,
                                      image: data[index].courseCreateduserInfo.image,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    width: 30,
                                    alignment: Alignment.centerLeft,
                                    color: Colors.transparent,
                                    child: const Icon(
                                      FontAwesomeIcons.arrowUpRightFromSquare,
                                      color: Colors.black87,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "最終更新日:${data[index].postTime}",
                                    style: TextStyle(fontSize: 11, color: hintTextColor),
                                  ),
                                  const Expanded(child: SizedBox(width: 1)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8, bottom: 5),
                                    child: Icon(
                                      data[index].isPublic || data[index].signUpStatus == "added"
                                          ? FontAwesomeIcons.unlock
                                          : FontAwesomeIcons.lock,
                                      size: 12,
                                      color: data[index].isPublic ? normalBgColor : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loadingBuilder: () {
              return const PostLoading();
            },
          ),
        ),
      ),
    ],
  );
}
