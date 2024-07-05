import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/states/course_state.dart';
import '../../home/coursePage/course_filter.dart';
import 'custom_end_drawer.dart';

enum CourseFilterEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseState

///MARK: void コースフィルターページ開くように
void openCourseFilterEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.open);
}

///MARK: void コースフィルターページ開くように
void closeCourseFilterEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.close);
}

///MARK: Widget コースフィルターページ用EndDrawer
Widget courseFilterEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseDetailEndDrawer");
      CourseFilterEndDrawerType endDrawer = context.select((CourseState value) => value.filterEndDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseFilterEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            closeCourseFilterEndDrawer(context: context);
          },

          /// コースフィルターページ
          child: const CourseFilterPage(),
        );
      }

      return endDrawerWidget;
    },
  );
}
