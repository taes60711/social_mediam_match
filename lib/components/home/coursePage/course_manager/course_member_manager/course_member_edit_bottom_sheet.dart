import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../../../../../models/course_model.dart';
import '../../../../../provider/course/course_provider.dart';
import '../../../../utilities/apiListView/api_list_controller.dart';
import '../../../../utilities/bottomSheets/base_bottom_sheet.dart';

class CourseMemberEditBtmSheet extends BaseBottomSheet {
  StateNotifierProvider<APIListControllerNotifier<AddedCourseMemberModel>, APIListController<AddedCourseMemberModel>>
      courseMemberListController;

  bool userIsDeleted;
  int dataIndex;
  CourseMemberEditBtmSheet(this.courseMemberListController, {required this.userIsDeleted, required this.dataIndex});

  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        Visibility(
          visible: !userIsDeleted && ref.read(choicedCourseMemberProvider).status == 0,
          child: managerPageMainBtn(
              iconData: FontAwesomeIcons.check,
              text: "審核通過",
              onPress: () async {
                AddedCourseMemberModel updateData = ref.read(choicedCourseMemberProvider);
                bool isSuccess = await CourseService().updateAddedUserStatus(
                  courseId: updateData.courseId,
                  userUID: updateData.memberUid,
                );
                if (isSuccess) {
                  updateData.status = 1;
                  ref.read(courseMemberListController.notifier).editData(dataIndex, updateData);
                  closePage();
                }
              }),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        managerPageMainBtn(
            iconData: FontAwesomeIcons.trash,
            text: "移除使用者",
            onPress: () async {
              AddedCourseMemberModel choiceData = ref.read(choicedCourseMemberProvider);
              bool isSuccess = await CourseService().deleteUserFromCourse(
                courseId: choiceData.courseId,
                userUID: choiceData.memberUid,
              );
              if (isSuccess) {
                ref.read(courseMemberListController.notifier).removeData(dataIndex);
                closePage();
              }
            }),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
      ],
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
            Icon(iconData, color: AppColors.whiteColor),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
