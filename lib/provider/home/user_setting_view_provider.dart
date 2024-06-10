import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/skill_model.dart';

import '../../enum/skill_type.dart';
import '../../states/services/skill_service.dart';

class SkillMapProvider extends ChangeNotifier {
  Map<SkillType, List<SkillModel>> skillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  Future<void> userSkillList() async {
    List<RequestSkillListData> requestSkillListData = await SkillService().requestSkillList();

    List<SkillModel> userSkillInfoList = [];

    ///データベースから資料がレベルに入る
    for (var skill in requestSkillListData) {
      RequestUserSkillData haveSkillItem = RequestUserSkillData(name: skill.name, level: 0, month: 0);
      RequestUserSkillData wantSkillItem = RequestUserSkillData(name: skill.name, level: 0, month: 0);
      SkillModel skillInfo = SkillModel(id: skill.id, skillHave: haveSkillItem, skillWant: wantSkillItem);
      userSkillInfoList.add(skillInfo);
    }

    ///スキルが種類より加工する
    for (var skillInfo in userSkillInfoList) {
      String skillName = skillInfo.skillHave.name;
      if (frontType.contains(skillName)) {
        ///front
        skillMap[SkillType.frontend]!.add(skillInfo);
      } else if (backendType.contains(skillName)) {
        ///back
        skillMap[SkillType.backend]!.add(skillInfo);
      } else if (iotType.contains(skillName)) {
        ///iot
        skillMap[SkillType.iot]!.add(skillInfo);
      } else {
        ///other
        skillMap[SkillType.other]!.add(skillInfo);
      }
    }
    notifyListeners();
  }

  void skillLevelChange(SkillModel s) {
    print("skillLevelChange ${s.skillHave.name}");
    s.skillHave.name = "12132";
    notifyListeners();
  }
}

class UserSettingViewProvider extends ChangeNotifier {
  TextEditingController nameInput = TextEditingController();
  TextEditingController jobInput = TextEditingController();
  TextEditingController introductionInput = TextEditingController();

  void inputOnChange(String value) {
    introductionInput.text = value;
    notifyListeners();
  }
}
