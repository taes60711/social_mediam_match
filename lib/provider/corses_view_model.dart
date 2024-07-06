// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/course_state.dart';
import 'package:social_mediam_match/services/course_service.dart';

import '../components/utilities/apiListView/base_api_list_provider.dart';
import '../components/utilities/endDrawers/course_detail_end_drawer.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';
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
}
