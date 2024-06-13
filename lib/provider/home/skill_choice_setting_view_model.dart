import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/utilities/custom_button.dart';
import '../../components/utilities/style/style_config.dart';
import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import 'skill_map_provider.dart';

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
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void skillChoice(SkillChoicePageType skillType, RequestUserSkillData changedSkill, int level) {
    SkillMapProvider skillMapProvider = context.read<SkillMapProvider>();

    switch (skillType) {
      case SkillChoicePageType.have:
        bool addMaxLength = skillMapProvider.haveSkillList.length >= 5;
        bool changeLevel = skillMapProvider.haveSkillList.any((element) => element.name == changedSkill.name);
        bool canel = level == 0;
        if (addMaxLength && !changeLevel && !canel) {
          print("can't add");
          warningPopView();

          return;
        }
        break;
      case SkillChoicePageType.want:
        bool addMaxLength = skillMapProvider.wantSkillList.length >= 5;
        bool changeLevel = skillMapProvider.wantSkillList.any((element) => element.name == changedSkill.name);
        bool canel = level == 0;
        if (addMaxLength && !changeLevel && !canel) {
          print("can't add");
          warningPopView();
          return;
        }
        break;
    }

    skillMapProvider.skillLevelChange(changedSkill, level);
  }
}
