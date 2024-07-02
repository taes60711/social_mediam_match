import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'custom_end_drawer.dart';

enum CourseFilterEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseState

///MARK: void コース詳細ページ開くように
void openCourseFilterEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.open);
}

///MARK: void コース詳細ページ開くように
void closeCourseFilterEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.close);
}

///MARK: Widget コース詳細ページ用EndDrawer
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

          /// ユーザ詳細ページ
          child: Container(
            width: 100,
            height: 20,
            color: const Color.fromARGB(255, 165, 63, 26),
          ),
        );
      }

      return endDrawerWidget;
    },
  );
}
