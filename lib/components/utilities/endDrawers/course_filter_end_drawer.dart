import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/skill_model.dart';
import '../../../provider/course_provider.dart';
import '../../../provider/home/skill_change_view_provider.dart';
import '../../home/coursePage/course_filter.dart';
import 'base_end_drawer.dart';

enum CourseFilterEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseProvider

///MARK: void コースフィルターページ開くように
void openCourseFilterEndDrawer({required BuildContext context}) {
  List<RequestSkillListData> tempChoicedSkillList = context.read<SkillChangeProvider>().tempChoicedSkill;
  context.read<SkillChangeProvider>().filteredListInitOrRecord(tempChoicedSkillList, status: "init");
  context.read<CourseProvider>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.open);
}

///MARK: void コースフィルターページ開くように
void closeCourseFilterEndDrawer({required BuildContext context}) {
  context.read<CourseProvider>().changeFilterEndDrawerStatus(CourseFilterEndDrawerType.close);
}

///MARK: Widget コースフィルターページ用EndDrawer
Widget courseFilterEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseDetailEndDrawer");
      CourseFilterEndDrawerType endDrawer = context.select((CourseProvider value) => value.filterEndDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseFilterEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          isNeedTopbar: false,
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
