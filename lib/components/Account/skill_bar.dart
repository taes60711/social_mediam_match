import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import '../../provider/home/user_setting_view_provider.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

Widget skillBar(SignUpEndDrawerType type, {required proivderType}) {
  if (proivderType is UserSettingViewProvider) {
    return Consumer<UserSettingViewProvider>(builder: (context, userSettingViewProvider, _) {
      List<RequestUserSkillData> skillData = userSettingViewProvider.haveSkillList;
      if (type != SignUpEndDrawerType.haveSkill) {
        skillData = userSettingViewProvider.wantSkillList;
      }

      return skillContent(skillData);
    });
  } else {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      List<RequestUserSkillData> skillData = userProvider.userData.mainSkills ?? [];
      if (type != SignUpEndDrawerType.haveSkill) {
        skillData = userProvider.userData.wantSkills ?? [];
      }

      return skillContent(skillData);
    });
  }
}

Widget skillContent(List<RequestUserSkillData> skillData) {
  var levelIcon = {
    1: Icons.filter_1,
    2: Icons.filter_2,
    3: Icons.filter_3,
    4: Icons.filter_4,
    5: Icons.filter_5,
  };
  return SizedBox(
    width: ScreenSize.width,
    child: Wrap(
      children: skillData.map((e) {
        return Container(
          margin: const EdgeInsets.only(right: 5, bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: googleButtonColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                levelIcon[e.level],
                color: normalTextColor,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                e.name,
                style: TextStyle(color: normalTextColor, fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
