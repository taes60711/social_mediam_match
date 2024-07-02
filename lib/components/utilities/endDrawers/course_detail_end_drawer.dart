import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'custom_end_drawer.dart';

enum CourseDetailEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseState

///MARK: void コース詳細ページ開くように
void openCourseDetailEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeEndDrawerStatus(CourseDetailEndDrawerType.open);
}

///MARK: void コース詳細ページ開くように
void closeCourseDetailEndDrawer({required BuildContext context}) {
  context.read<CourseState>().changeEndDrawerStatus(CourseDetailEndDrawerType.close);
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
          child: Container(
            width: 100,
            height: 20,
            color: Colors.brown,
          ),
        );
      }

      return endDrawerWidget;
    },
  );
}
