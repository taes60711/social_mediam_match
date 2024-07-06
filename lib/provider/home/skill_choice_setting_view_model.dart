import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import '../../components/utilities/custom_button.dart';
import '../../components/utilities/endDrawers/skill_setting_end_drawer.dart';
import '../../components/utilities/style/style_config.dart';

import '../../models/skill_model.dart';
import 'skill_map_provider.dart';
import 'user_setting_view_provider.dart';

class SKillChoiceSettingViewModel {
  BuildContext context;
  SKillChoiceSettingViewModel({required this.context});

  Future<void> warningPopView() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 180,
            height: 150,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text('最多只能選擇五個技能'),
                ),
                CustomButton(
                  title: '確認',
                  titleColor: normalTextColor,
                  backgroundColor: normalBgColor,
                  onPress: () {
                    RouteOptions.pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void skillChoice(SkillEndDrawerType skillType, RequestUserSkillData changedSkill, int level) {
    SkillMapProvider skillMapProvider = context.read<SkillMapProvider>();
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();

    switch (skillType) {
      case SkillEndDrawerType.haveSkill:
        bool addMaxLength = userSettingViewProvider.haveSkillList.length >= 5;
        bool changeLevel = userSettingViewProvider.haveSkillList.any((element) => element.name == changedSkill.name);
        bool canel = level == 0;
        if (addMaxLength && !changeLevel && !canel) {
          print("can't add");
          warningPopView();

          return;
        }
        break;
      case SkillEndDrawerType.wantSkill:
        bool addMaxLength = userSettingViewProvider.wantSkillList.length >= 5;
        bool changeLevel = userSettingViewProvider.wantSkillList.any((element) => element.name == changedSkill.name);
        bool canel = level == 0;
        if (addMaxLength && !changeLevel && !canel) {
          print("can't add");
          warningPopView();
          return;
        }
        break;
      case SkillEndDrawerType.close:
        return;
    }

    userSettingViewProvider.changeSkillList(skillMapProvider.skillLevelChange(changedSkill, level));
  }
}
