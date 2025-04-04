import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_utilites.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/report_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../../../../global/home_global_view_model.dart';
import '../../../../models/course_model.dart';

import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';

class MyCourseManagerBtmSheet extends BaseBottomSheet {
  StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController;

  int dataIndex;
  MyCourseManagerBtmSheet(
    this.courseListController, {
    required this.dataIndex,
    Function? anotherLikeFunc,
  });

  @override
  double buildHeight() {
    return 0.35;
  }

  @override
  Widget build(WidgetRef ref) {
    CourseModel choiceCourse = ref.read(courseListController).listData[dataIndex];
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.arrowUpRightFromSquare,
            text: "分享",
            onPress: () async {
              await CourseUtilites().shareCourse(courseId: choiceCourse.id);
            },
          ),
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          choiceCourse.isLike
              ? managerPageMainBtn(
                  iconData: FontAwesomeIcons.solidBookmark,
                  text: "取消收藏",
                  onPress: () async {
                    bool isSuccess = await CourseUtilites().likeStatusOnChange(
                      ref,
                      context,
                      courseListController: courseListController,
                      dataIndex: dataIndex,
                      data: choiceCourse,
                    );
                    if (isSuccess) {
                      render();
                    }
                  },
                )
              : managerPageMainBtn(
                  iconData: FontAwesomeIcons.bookmark,
                  text: "收藏",
                  onPress: () async {
                    bool isSuccess = await CourseUtilites().likeStatusOnChange(
                      ref,
                      context,
                      courseListController: courseListController,
                      dataIndex: dataIndex,
                      data: choiceCourse,
                    );
                    if (isSuccess) {
                      render();
                    }
                  },
                ),
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.userLock,
            text: "封鎖用戶",
            onPress: () async {
              HomeGlobalViewModel().blockUser(userData: choiceCourse.courseCreateduserInfo);
            },
          ),
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.circleExclamation,
            text: "檢舉",
            onPress: () async {
              ReportBtmSheet(reportTitle: '技術文章 : ${choiceCourse.id}').show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget managerPageMainBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
          vertical: ScreenSize.fitPxWidth(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor54,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize14,
            ),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
