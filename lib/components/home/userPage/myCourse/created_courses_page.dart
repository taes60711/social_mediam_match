import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';

import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../provider/course/course_provider.dart';
import '../../../../services/course_service.dart';

import '../../../utilities/apiListView/api_list_view.dart';
import '../../coursePage/course_utilites.dart';

class CreatedCoursePage extends ConsumerStatefulWidget {
  const CreatedCoursePage({super.key});

  @override
  ConsumerState<CreatedCoursePage> createState() => _CreatedCourseState();
}

class _CreatedCourseState extends ConsumerState<CreatedCoursePage> {
  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return APIListWidget(
        apiFunc: (page, size) {
          return CourseService().getCreatedCourses(page, size, userData.uid);
        },
        listControllerProvider: createdCourserListPorver,
        loadingWidget: const CourseLoading(),
        noDataWidget: CourseUtilites.noCourseData(),
        itemChild: (data, index) {
          return CourseUtilites().courseItemContent(context, ref, createdCourserListPorver, data: data, dataIndex: index);
        });
  }
}
