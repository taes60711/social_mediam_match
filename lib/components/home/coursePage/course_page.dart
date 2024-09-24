import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/skill_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/skill_setting_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/provider/corse_view_model.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../../../global.dart';
import '../../../pagemanager/enum/route_path.dart';
import '../../../pagemanager/setting/route_controller.dart';
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
      child: Stack(
        children: [
          _mainBuild(context),
          courseDetailEndDrawer(),
          userDetailEndDrawer(),
          courseFilterEndDrawer(),
        ],
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
          child: const Icon(Icons.dehaze_rounded),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: APIListView<CourseModel>(
            apiFunc: (int page, int size) {
              return CourseService().getAllCourses(page, size);
            },
            providerList: context.watch<BaseAPIListProvider<CourseModel>>().listData,
            customFloatbutton: GestureDetector(
              onTap: () {
                RouteOptions.pushTo(RoutePath.courseEditPage, arguments: {
                  'context': context,
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
              print(data);
              return GestureDetector(
                onTap: () {
                  CourseViewModel(courseContext: context).courseDetailInit(openedCourse: data[index]);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: googleColor, borderRadius: BorderRadius.circular(3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index].title,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                skillBar(SkillEndDrawerType.close,
                                    courseSkillData: data[index].courseLearningSkills,
                                    backGroundColor: normalBgColor2.withAlpha(150),
                                    fontSize: 10),
                                Text(
                                  "難度: ${data[index].needLevel}",
                                  style: TextStyle(fontSize: 12, color: normalTextColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "課程大綱: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              data[index].content,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              "課程前需要: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              data[index].beforeNeed,
                              style: TextStyle(color: hintTextColor, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                                  Text(
                                    data[index].courseCreateduserInfo.name != ""
                                        ? data[index].courseCreateduserInfo.name ?? ""
                                        : data[index].courseCreateduserInfo.email,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                "最終更新日:${data[index].postTime}",
                                style: TextStyle(fontSize: 11, color: hintTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 0.3,
                        width: ScreenSize.width,
                        color: hintTextColor,
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
