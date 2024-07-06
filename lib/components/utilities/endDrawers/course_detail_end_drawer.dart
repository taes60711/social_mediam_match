import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/course_state.dart';
import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../home/coursePage/course_detail.dart';
import 'custom_end_drawer.dart';

enum CourseDetailEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseState

///MARK: void コース詳細ページ開くように
void openCourseDetailEndDrawer({required BuildContext context, required CourseModel openedCourse}) {
  context.read<CourseState>().changeEndDrawerStatus(CourseDetailEndDrawerType.open, openedCourse);
}

///MARK: void コース詳細ページ開くように
void closeCourseDetailEndDrawer({required BuildContext context}) {
  context
      .read<CourseState>()
      .changeEndDrawerStatus(CourseDetailEndDrawerType.close, CourseModel(courseCreateduserInfo: LoginUser()));
}

///MARK: Widget コース詳細ページ用EndDrawer
Widget courseDetailEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseDetailEndDrawer");
      CourseDetailEndDrawerType endDrawer = context.select((CourseState value) => value.endDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseDetailEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            closeCourseDetailEndDrawer(context: context);
          },

          /// コース詳細ページ
          child: const CourseDetail(),
        );
      }

      return endDrawerWidget;
    },
  );
}
