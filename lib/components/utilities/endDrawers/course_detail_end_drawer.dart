import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/course_provider.dart';
import '../../home/coursePage/course_detail.dart';
import '../loading.dart';
import 'custom_end_drawer.dart';

enum CourseDetailEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseProvider

///MARK: void コース詳細ページ開くように
void openCourseDetailEndDrawer({required BuildContext context, required CourseModel openedCourse}) {
  context.read<CourseProvider>().changeEndDrawerStatus(CourseDetailEndDrawerType.open, openedCourse);
}

///MARK: void コース詳細ページ開くように
void closeCourseDetailEndDrawer({required BuildContext context}) {
  context
      .read<CourseProvider>()
      .changeEndDrawerStatus(CourseDetailEndDrawerType.close, CourseModel(courseCreateduserInfo: ProfileData()));
}

///MARK: Widget コース詳細ページ用EndDrawer
Widget courseDetailEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseDetailEndDrawer");
      CourseDetailEndDrawerType endDrawer = context.select((CourseProvider value) => value.endDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseDetailEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            closeCourseDetailEndDrawer(context: context);
          },
          loadingBuilder: const Loading(),

          /// コース詳細ページ
          child: const CourseDetail(),
        );
      }

      return endDrawerWidget;
    },
  );
}
