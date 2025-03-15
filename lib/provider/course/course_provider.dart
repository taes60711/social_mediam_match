import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/models/course_model.dart';

import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../models/skill_model.dart';
import '../../models/user_model.dart';

final addedCourserListPorver = StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>>(
  (ref) => APIListControllerNotifier<CourseModel>(APIListController()),
);

final createdCourserListPorver = StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>>(
  (ref) => APIListControllerNotifier<CourseModel>(APIListController()),
);

final courseByTextFilterListPorver =
    StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>>(
  (ref) => APIListControllerNotifier<CourseModel>(APIListController()),
);

final likedCourserListPorver = StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>>(
  (ref) => APIListControllerNotifier<CourseModel>(APIListController()),
);

final couseFilteredSkillList = StateProvider<List<RequestSkillListData>>((ref) {
  return [];
});

final courseMemberManagerListPorver =
    StateNotifierProvider<APIListControllerNotifier<AddedCourseMemberModel>, APIListController<AddedCourseMemberModel>>(
  (ref) => APIListControllerNotifier<AddedCourseMemberModel>(APIListController()),
);

final choicedCourseMemberProvider = StateProvider<AddedCourseMemberModel>((ref) {
  return AddedCourseMemberModel(courseId: 0, memberUid: '', userData: ProfileData(), status: 0);
});

final courseMainPageListPorver = StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>>(
  (ref) => APIListControllerNotifier<CourseModel>(APIListController()),
);

final choicedCourseProvider = StateProvider<CourseModel>((ref) {
  return CourseModel(courseCreateduserInfo: ProfileData());
});
