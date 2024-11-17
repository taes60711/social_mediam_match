import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';

import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';

import '../../../../provider/course/course_provider.dart';
import '../../../../services/course_service.dart';

import '../../../utilities/apiListView/api_list_view.dart';
import '../../coursePage/course_utilites.dart';

class AddedCoursePage extends ConsumerStatefulWidget {
  const AddedCoursePage({super.key});

  @override
  ConsumerState<AddedCoursePage> createState() => _PostByViewState();
}

class _PostByViewState extends ConsumerState<AddedCoursePage> {
  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return APIListWidget(
      apiFunc: (page, size) {
        return CourseService().getAddedCourses(page, size, userData.uid);
      },
      listControllerProvider: addedCourserListPorver,
      loadingWidget: const CourseLoading(),
      itemChild: (data, index) {
        return CourseUtilites().courseItemContent(context, ref, addedCourserListPorver, data: data, dataIndex: index);
      },
    );
  }
}
