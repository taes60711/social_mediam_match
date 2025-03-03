import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_manager/course_edit_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_utilites.dart';
import 'package:social_mediam_match/components/utilities/dialog/cant_touch_loading_dialog.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../../../../models/course_model.dart';

import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';
import 'course_member_manager/course_member_manager_page.dart';

class CourseManagerBtmSheet extends BaseBottomSheet {
  StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController;

  int dataIndex;
  CourseManagerBtmSheet(this.courseListController, {required this.dataIndex});

  @override
  double buildHeight() {
    return 0.34;
  }

  @override
  Widget build(WidgetRef ref) {
    CourseModel choiceCourse = ref.read(courseListController).listData[dataIndex];
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxWidth(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
            child: Row(
              children: [
                Expanded(
                  child: managernormalBtn(
                      iconData: FontAwesomeIcons.penToSquare,
                      text: "編輯課程",
                      onPress: () {
                        CourseEditPage(courseListController, dataIndex: dataIndex).show(context);
                      }),
                ),
                SizedBox(width: ScreenSize.fitPxWidth(10)),
                Expanded(
                  child: managernormalBtn(
                    iconData: FontAwesomeIcons.gears,
                    text: "管理成員",
                    onPress: () {
                      CourseMemberManagerPage().show(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxWidth(10)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.arrowUpRightFromSquare,
            text: "分享",
            onPress: () async {
              await CourseUtilites().shareCourse(courseId: choiceCourse.id);
            },
          ),
          SizedBox(height: ScreenSize.fitPxWidth(10)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.trash,
            text: "刪除課程",
            onPress: () {
              ConfirmDilaog(
                title: "警告",
                content: "確定要刪除該課程?",
                conirmFunc: () async {
                  CanTouchScreenLoadingDialog().show();
                  await CourseService().deleteCourse(courseId: choiceCourse.id);
                  CanTouchScreenLoadingDialog().close();

                  ref.read(courseListController.notifier).removeData(dataIndex);
                  closePage();
                },
              ).show(context);
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

  Widget managernormalBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(58),
          vertical: ScreenSize.fitPxWidth(13),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor54,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Column(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize14,
            ),
            SizedBox(height: ScreenSize.fitPxWidth(10)),
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
