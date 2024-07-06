// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/provider/course_state.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../components/utilities/apiListView/base_api_list_provider.dart';
import '../components/utilities/endDrawers/course_detail_end_drawer.dart';
import '../components/utilities/endDrawers/course_manager_end_drawer.dart';
import '../components/utilities/style/style_config.dart';
import '../global.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';
import '../pagemanager/enum/route_path.dart';
import '../pagemanager/setting/route_controller.dart';
import 'account/user_provider.dart';

class CoursesViewModel {
  BuildContext courseContext;
  CoursesViewModel({required this.courseContext});

  Future<void> courseDetailInit({required CourseModel openedCourse}) async {
    openCourseDetailEndDrawer(context: courseContext, openedCourse: openedCourse);
    LoginUser userData = courseContext.read<UserProvider>().userData;
    bool isAdded = await CourseService().isAddedCourse(courseId: openedCourse.id, userUID: userData.uid);
    courseContext.read<CourseState>().isAddedCourse(isAdded: isAdded);
  }

  Future<void> courseSignUp({required int courseId}) async {
    LoginUser userData = courseContext.read<UserProvider>().userData;
    bool isSignedUp = await CourseService().signUpCourse(userUID: userData.uid, courseId: courseId);
    courseContext.read<CourseState>().courseSignedUp(isSucess: isSignedUp);
  }

  Future<void> updateCourseMemberStatus({required AddedCourseMemberModel updateData}) async {
    await CourseService().updateAddedUserStatus(courseId: updateData.courseId, userUID: updateData.memberUid);
    courseContext.read<BaseAPIListProvider<AddedCourseMemberModel>>().onChoiceData(choicedData: updateData);
    AddedCourseMemberModel updatedData = updateData;
    updatedData.status = 1;
    courseContext.read<BaseAPIListProvider<AddedCourseMemberModel>>().editData(updatedData: updatedData);
  }

  Future<void> deleteCourseMember({required AddedCourseMemberModel deletedMember}) async {
    await CourseService().deleteUserFromCourse(courseId: deletedMember.courseId, userUID: deletedMember.memberUid);
    courseContext.read<BaseAPIListProvider<AddedCourseMemberModel>>().deleteData(choiceData: deletedMember);
  }

  void openCreatedCourseModal({required CourseModel courseData}) {
    showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 150,
            height: 180,
            child: Column(
              children: [
                BaseTopBar(
                  leftWidget: Container(),
                  rightWidget: GestureDetector(
                    onTap: () => RouteOptions.pop(),
                    child: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomButton(
                        title: '編輯課程',
                        titleColor: normalTextColor,
                        backgroundColor: normalBgColor2,
                        onPress: () {
                          LoginUser userData = courseContext.read<UserProvider>().userData;
                          RouteOptions.pop();
                          RouteOptions.pushTo(RoutePath.courseEditPage.value, arguments: {
                            "userData": userData,
                            "courseData": courseData,
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        title: '管理成員',
                        titleColor: normalTextColor,
                        backgroundColor: normalBgColor2,
                        onPress: () {
                          RouteOptions.pop();
                          opencourseManagerEndDrawer(context: courseContext, courseId: courseData.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
