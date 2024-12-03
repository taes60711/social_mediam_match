import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/course/course_provider.dart';
import '../../../services/course_service.dart';

import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import 'course_utilites.dart';

class CoursePageByTextFilter extends BaseEndDrawer {
  final String searchText;
  CoursePageByTextFilter({required this.searchText});
  @override
  Widget build(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        const BaseTopBar(),
        Expanded(
          child: APIListWidget(
              apiFunc: (int page, int size) {
                return CourseService().getAllCourses(userData.uid, page, size, namePart: searchText);
              },
              listControllerProvider: courseByTextFilterListPorver,
              loadingWidget: const CourseLoading(),
              noDataWidget: CourseUtilites.noCourseData(),
              itemChild: (data, index) {
                return CourseUtilites().courseItemContent(context, ref, courseMainPageListPorver, data: data, dataIndex: index);
              }),
        ),
      ],
    );
  }
}
