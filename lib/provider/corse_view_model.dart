// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/course_filter_end_drawer.dart';
import 'package:social_mediam_match/services/course_service.dart';
import 'package:social_mediam_match/services/skill_service.dart';

import '../components/home/coursePage/course_edit_page/course_rich_text_edit.dart';
import '../components/utilities/apiListView/base_api_list_provider.dart';
import '../components/utilities/endDrawers/course_detail_end_drawer.dart';
import '../components/utilities/endDrawers/course_manager_end_drawer.dart';
import '../components/utilities/rich_text_view.dart';
import '../components/utilities/style/style_config.dart';
import '../global.dart';
import '../models/course_model.dart';
import '../models/skill_model.dart';
import '../models/user_model.dart';

import '../pagemanager/setting/route_controller.dart';
import 'account/user_provider.dart';
import 'course_provider.dart';
import 'home/skill_change_view_provider.dart';

class CourseViewModel {
  BuildContext courseContext;
  CourseViewModel({required this.courseContext});

  // Future<void> courseDetailInit({required CourseModel openedCourse}) async {
  //   openCourseDetailEndDrawer(context: courseContext, openedCourse: openedCourse);
  // }

  Future<void> courseEditInit({CourseModel? courseData}) async {
    List<RequestSkillListData> requestSkillList = await SkillService().requestSkillList();
    List<String> skillList = requestSkillList.map((e) => e.name).toList();
    courseContext.read<CourseProvider>().editPageInit(requestSkillList: skillList, courseData: courseData);
  }

  Future<void> courseFilterSearchStart() async {
    List<RequestSkillListData> filteredSkillList = courseContext.read<SkillChangeProvider>().filteredSkill;
    courseContext.read<SkillChangeProvider>().filteredListInitOrRecord(filteredSkillList, status: "record");
    List<String> filteredSkillIdsList = filteredSkillList.map((e) {
      return e.id.toString();
    }).toList();

    ProfileData userData = courseContext.read<UserProvider>().userData;
    int loadSize = courseContext.read<BaseAPIListProvider<CourseModel>>().size;
    await courseContext.read<BaseAPIListProvider<CourseModel>>().replaceApiFunc(
      loadSize,
      replaceApiFunc: (page, size) {
        return CourseService().getAllCourses(userData.uid, page, size, skillId: filteredSkillIdsList);
      },
    );

    closeCourseFilterEndDrawer(context: courseContext);
  }

  Future<void> courseCreateOrUpdate({int? courseId, required BuildContext viewListContext}) async {
    await CourseService().createOrUpdateCourse(
      courseId: courseId,
      createdBy: courseContext.read<UserProvider>().userData.uid,
      title: courseContext.read<CourseProvider>().titleController.text,
      needLevel: courseContext.read<CourseProvider>().needLevel,
      content: courseContext.read<CourseProvider>().contentText,
      beforeNeed: courseContext.read<CourseProvider>().beforeNeedText,
      prStory: courseContext.read<CourseProvider>().prStory,
      chapterList: courseContext.read<CourseProvider>().chapters,
      courseLearningSkills: courseContext.read<CourseProvider>().choicedSkillList,
      type: "1",
      isPublic: courseContext.read<CourseProvider>().isPublic,
    );

    RouteOptions.pop();

    ProfileData userData = viewListContext.read<UserProvider>().userData;
    if (courseId == null) {
      int loadSize = viewListContext.read<BaseAPIListProvider<CourseModel>>().size;
      await viewListContext.read<BaseAPIListProvider<CourseModel>>().replaceApiFunc(
        loadSize,
        replaceApiFunc: (page, size) {
          return CourseService().getAllCourses(userData.uid, page, size);
        },
      );
    } else {
      int loadSize = viewListContext.read<BaseAPIListProvider<CourseModel>>().size;
      await viewListContext.read<BaseAPIListProvider<CourseModel>>().replaceApiFunc(
        loadSize,
        replaceApiFunc: (page, size) {
          return CourseService().getCreatedCourses(page, size, userData.uid);
        },
      );
    }
  }

  void openRichEditPage({int? chapterIndex, String? prStory}) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: courseContext,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: CourseRichTextEdit(
            index: chapterIndex,
            courseContext: courseContext,
            prStory: prStory,
          ),
        );
      },
    );
  }

  void openCourseChapterContentPage({required String chapterText, required String chapterUrl}) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: courseContext,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Scaffold(
            body: Column(
              children: [
                BaseTopBar(title: chapterText),
                Expanded(
                  child: SingleChildScrollView(
                    child: RichTextView(content: chapterUrl),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> courseSignUp({required CourseModel choicedCourse}) async {
    showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 150,
            height: 150,
            child: Column(
              children: [
                const SizedBox(height: 10),
                BaseTopBar(
                  leftWidget: Container(),
                  centerWidget: const Text("確認要申請?"),
                  rightWidget: GestureDetector(
                    onTap: () => RouteOptions.pop(),
                    child: const Icon(Icons.close),
                  ),
                ),
                const Expanded(child: SizedBox(height: 10)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextBtn(
                          title: '取消',
                          titleColor: normalTextColor,
                          btnColor: hintTextColor,
                          onPress: () {
                            RouteOptions.pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextBtn(
                          title: '確認',
                          titleColor: normalTextColor,
                          btnColor: normalBgColor,
                          onPress: () async {
                            ProfileData userData = courseContext.read<UserProvider>().userData;
                            CourseModel updateCourse = choicedCourse;
                            updateCourse.signUpStatus = "signing";
                            await CourseService().signUpCourse(userUID: userData.uid, courseId: choicedCourse.id);
                            courseContext.read<BaseAPIListProvider<CourseModel>>().onChoiceData(choicedData: choicedCourse);

                            courseContext.read<BaseAPIListProvider<CourseModel>>().editData(updatedData: updateCourse);

                            courseContext.read<CourseProvider>().onChangeDetailPage(updateCourse);
                            RouteOptions.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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

  // void openCreatedCourseModal({required CourseModel courseData}) {
  //   showDialog<void>(
  //     context: courseContext,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.zero,
  //         content: SizedBox(
  //           width: 150,
  //           height: 230,
  //           child: Column(
  //             children: [
  //               BaseTopBar(
  //                 leftWidget: Container(),
  //                 title: "請選擇",
  //                 rightWidget: GestureDetector(
  //                   onTap: () => RouteOptions.pop(),
  //                   child: const Icon(Icons.close),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20),
  //                 child: Column(
  //                   children: [
  //                     TextBtn(
  //                       title: '開啟課程',
  //                       titleColor: normalTextColor,
  //                       btnColor: normalBgColor2,
  //                       onPress: () {
  //                         RouteOptions.pop();
  //                         // CourseViewModel(courseContext: courseContext).courseDetailInit(openedCourse: courseData);
  //                       },
  //                     ),
  //                     const SizedBox(height: 15),
  //                     TextBtn(
  //                       title: '編輯課程',
  //                       titleColor: normalTextColor,
  //                       btnColor: normalBgColor2,
  //                       onPress: () {
  //                         RouteOptions.pop();
  //                         RouteOptions.pushTo(RoutePath.courseEditPage, arguments: {
  //                           "courseData": courseData,
  //                           "context": courseContext,
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(height: 15),
  //                     TextBtn(
  //                       title: '管理成員',
  //                       titleColor: normalTextColor,
  //                       btnColor: normalBgColor2,
  //                       onPress: () {
  //                         RouteOptions.pop();
  //                         opencourseManagerEndDrawer(context: courseContext, courseId: courseData.id);
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
