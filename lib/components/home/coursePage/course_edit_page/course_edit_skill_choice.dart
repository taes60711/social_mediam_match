import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../../provider/course_provider.dart';

import '../../../utilities/style/style_config.dart';

class CourseEditSkillChoice extends StatelessWidget {
  const CourseEditSkillChoice({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> skillList = context.select((CourseProvider value) => value.skillList);
    List<String> choicedSkillList = context.watch<CourseProvider>().choicedSkillList;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: normalBgColor2.withOpacity(0.1),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: skillList.map((e) {
              return GestureDetector(
                onTap: () {
                  context.read<CourseProvider>().onChangeChoiceSkill(e);
                },
                child: Container(
                  width: ScreenSize.width,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: choicedSkillList.any((element) => element == e) ? normalBgColor : normalBgColor2.withOpacity(0.1),
                  ),
                  child: Text(e),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
