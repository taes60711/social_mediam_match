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

  List<RequestUserSkillData> haveSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];

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
    _skillToTypList(userSkillInfoList);

    notifyListeners();
  }

  ///スキルが種類より加工する
  void _skillToTypList(List<SkillModel> userSkillInfoList) {
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
  }

  void skillLevelChange(SkillModel changedSkill, int level, String type) {
    print("skillLevelChange ${changedSkill.skillHave.name}");
    if (type == "have") {
      changedSkill.skillHave.level = level;
    } else {
      changedSkill.skillWant.level = level;
    }

    typeListToSkill();
    notifyListeners();
  }

  void typeListToSkill() {
    for (var e in SkillType.values) {
      for (var ele in skillMap[e]!) {
        if (ele.skillHave.level > 0) {
          if (haveSkillList.any((element) => element.name == ele.skillHave.name)) {
            haveSkillList.where((element) => element.name == ele.skillHave.name).first.level = ele.skillHave.level;
          } else {
            haveSkillList.add(ele.skillHave);
          }
        } else if (ele.skillHave.level == 0) {
          haveSkillList.remove(ele.skillHave);
        }
        if (ele.skillWant.level > 0) {
          if (wantSkillList.any((element) => element.name == ele.skillWant.name)) {
            wantSkillList.where((element) => element.name == ele.skillWant.name).first.level = ele.skillWant.level;
          } else {
            wantSkillList.add(ele.skillWant);
          }
        } else if (ele.skillWant.level == 0) {
          wantSkillList.remove(ele.skillWant);
        }
      }
    }
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
