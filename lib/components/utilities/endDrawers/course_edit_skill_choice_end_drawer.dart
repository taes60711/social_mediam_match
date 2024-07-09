import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/course_provider.dart';
import '../../home/coursePage/course_edit_page/course_edit_skill_choice.dart';

import 'custom_end_drawer.dart';

enum CourseEditSkillChoiceEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create CourseProvider

///MARK: void コース編集ページのスキルページ開くように
void openCoursEditSkillEndDrawer({required BuildContext context}) {
  context.read<CourseProvider>().editSkillChoiceEndDrawerStatus(CourseEditSkillChoiceEndDrawerType.open);
}

///MARK: void コース編集ページのスキルページ開くように
void closeCoursEditSkillEndDrawer({required BuildContext context}) {
  context.read<CourseProvider>().editSkillChoiceEndDrawerStatus(CourseEditSkillChoiceEndDrawerType.close);
}

///MARK: Widget コース編集ページのスキルページ用EndDrawer
Widget coursEditSkillEndDrawer() {
  return Builder(
    builder: (context) {
      print("courseDetailEndDrawer");
      CourseEditSkillChoiceEndDrawerType endDrawer =
          context.select((CourseProvider value) => value.editSkillChoiceEndDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == CourseEditSkillChoiceEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            closeCoursEditSkillEndDrawer(context: context);
          },
          title: "選擇技能",

          /// コース編集ページのスキルページ
          child: const CourseEditSkillChoice(),
        );
      }

      return endDrawerWidget;
    },
  );
}
