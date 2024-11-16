import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/course_provider.dart';

import '../../../../../services/course_service.dart';
import '../../../../utilities/apiListView/api_list_view.dart';
import '../../../../utilities/background_widget.dart';

import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/style/style_config.dart';
import '../../../../utilities/user_icon.dart';
import '../../../skillExChangePage/skill_utilites.dart';
import 'course_member_edit_bottom_sheet.dart';

class CourseMemberManagerPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseTopBar(
            backFunc: () => closePage(),
            title: "管理成員",
          ),
          Expanded(
            child: APIListWidget(
              apiFunc: (int page, int size) {
                int courseId = ref.read(choicedCourseProvider).id;
                return CourseService().getCourseAddedMember(page, size, courseId);
              },
              listControllerProvider: courseMemberManagerListPorver,
              itemChild: (data, index) {
                ProfileData signingUserData = data.userData;
                return MainBtn(
                  onPress: () {
                    ref.read(choicedCourseMemberProvider.notifier).update((e) => data);
                    CourseMemberEditBtmSheet(courseMemberManagerListPorver, dataIndex: index).show(context);
                  },
                  child: Container(
                    width: ScreenSize.width,
                    decoration: BoxDecoration(
                        color: AppColors.black37,
                        borderRadius: BorderRadius.circular(
                          ScreenSize.fitPxWidth(15),
                        )),
                    margin: EdgeInsets.only(
                      left: ScreenSize.fitPxHeight(10),
                      right: ScreenSize.fitPxHeight(10),
                      top: ScreenSize.fitPxHeight(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.fitPxHeight(8),
                      horizontal: ScreenSize.fitPxHeight(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserIcon(
                              iconSize: ScreenSize.fitPxWidth(55),
                              image: signingUserData.image,
                              borderRadius: 15,
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        signingUserData.name ?? "",
                                        style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                                      Visibility(
                                        visible: signingUserData.job != null,
                                        child: Icon(
                                          FontAwesomeIcons.briefcase,
                                          color: AppColors.greyColor130,
                                          size: ScreenSize.fontSize12,
                                        ),
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(2)),
                                      Text(
                                        signingUserData.job ?? "",
                                        style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    signingUserData.introduction ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${signingUserData.lastLogin}前",
                              style: TextStyle(color: hintTextColor, fontSize: 12),
                            ),
                          ],
                        ),

                        SizedBox(height: ScreenSize.fitPxHeight(5)),

                        ///得意なスキル
                        Row(
                          children: [
                            ///タイトル
                            Container(
                              padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                              margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 138, 138, 138),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                FontAwesomeIcons.reply,
                                color: AppColors.whiteColor,
                                size: ScreenSize.fitPxWidth(8),
                              ),
                            ),

                            ///スキル
                            SkillUtilites().skillBar(skills: signingUserData.mainSkills!),
                          ],
                        ),

                        SizedBox(height: ScreenSize.fitPxHeight(3)),

                        ///弱いスキル
                        Row(
                          children: [
                            ///タイトル
                            Container(
                              padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                              margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 123, 77),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                FontAwesomeIcons.share,
                                color: AppColors.whiteColor,
                                size: ScreenSize.fitPxWidth(8),
                              ),
                            ),

                            ///スキル
                            Expanded(child: SkillUtilites().skillBar(skills: signingUserData.wantSkills!)),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(3)),
                              decoration: BoxDecoration(
                                color: data.status == 0 ? AppColors.orangeColor : Colors.green,
                                borderRadius: BorderRadius.circular(
                                  ScreenSize.fitPxWidth(5),
                                ),
                              ),
                              child: Text(
                                data.status == 0 ? "審核中" : "已加入",
                                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
