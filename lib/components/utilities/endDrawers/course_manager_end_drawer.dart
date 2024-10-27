import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/course_model.dart';
import '../../../provider/course_provider.dart';
import '../../home/userPage/myCourse/courses_member_manager.dart';
import '../apiListView/base_api_list_provider.dart';
import 'base_end_drawer.dart';

enum CourseManagerEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseState

///MARK: void コース管理ページ開くように
void opencourseManagerEndDrawer({required BuildContext context, required int courseId}) {
  context.read<CourseProvider>().courseManagerEndDrawerStatus(CourseManagerEndDrawerType.open, courseId);
}

///MARK: void コース管理ページ開くように
void closecourseManagerEndDrawer({required BuildContext context}) {
  context.read<CourseProvider>().courseManagerEndDrawerStatus(CourseManagerEndDrawerType.close, -1);
}

///MARK: Widget コース管理ページ用EndDrawer
Widget courseManagerEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseManagerEndDrawer");
      CourseManagerEndDrawerType endDrawer = context.select((CourseProvider value) => value.courseManagerEndDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseManagerEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          title: "管理成員",
          onDismissed: () {
            closecourseManagerEndDrawer(context: context);
          },

          /// コース管理ページ
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BaseAPIListProvider<AddedCourseMemberModel>()),
            ],
            child: const CourseMemberManager(),
          ),
        );
      }

      return endDrawerWidget;
    },
  );
}
