import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/course_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../services/course_service.dart';
import '../../../account/skill_bar.dart';
import '../../../utilities/apiListView/api_list_view.dart';
import '../../../utilities/apiListView/base_api_list_provider.dart';
import '../../../utilities/endDrawers/course_manager_end_drawer.dart';
import '../../../utilities/endDrawers/skill_setting_end_drawer.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';

class CreatedCoursesPage extends StatelessWidget {
  const CreatedCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = context.watch<UserProvider>().userData;
    return APIListView<CourseModel>(
      providerList: context.watch<BaseAPIListProvider<CourseModel>>().listData,
      apiFunc: (page, size) {
        return CourseService().getCreatedCourses(page, size, userData.uid);
      },
      itemChild: ((data, index) {
        return GestureDetector(
          onTap: () {
            opencourseManagerEndDrawer(context: context, courseId: data[index].id);
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
              ],
            ),
          ),
        );
      }),
      loadingBuilder: () {
        return Container();
      },
    );
  }
}
