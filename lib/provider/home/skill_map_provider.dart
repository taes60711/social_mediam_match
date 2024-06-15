import 'package:flutter/material.dart';

import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import '../../services/skill_service.dart';

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

  Map<String, List<RequestUserSkillData>> skillLevelChange(RequestUserSkillData changedSkill, int level) {
    print("skillLevelChange ${changedSkill.name}");
    changedSkill.level = level;
    notifyListeners();
    return typeListToSkill();
  }

  Map<String, List<RequestUserSkillData>> typeListToSkill() {
    List<RequestUserSkillData> haveSkillList = [];
    List<RequestUserSkillData> wantSkillList = [];
    for (var e in SkillType.values) {
      for (var ele in skillMap[e]!) {
        if (ele.skillHave.level > 0) {
          ///持っているスキル追加または、調整レベル
          if (haveSkillList.any((element) => element.name == ele.skillHave.name)) {
            haveSkillList.where((element) => element.name == ele.skillHave.name).first.level = ele.skillHave.level;
          } else {
            haveSkillList.add(ele.skillHave);
          }
        } else if (ele.skillHave.level == 0) {
          ///持っているスキル削除
          haveSkillList.remove(ele.skillHave);
        }
        if (ele.skillWant.level > 0) {
          ///勉強したいスキル追加または、調整レベル
          if (wantSkillList.any((element) => element.name == ele.skillWant.name)) {
            wantSkillList.where((element) => element.name == ele.skillWant.name).first.level = ele.skillWant.level;
          } else {
            wantSkillList.add(ele.skillWant);
          }
        } else if (ele.skillWant.level == 0) {
          ///勉強したいスキル削除
          wantSkillList.remove(ele.skillWant);
        }
      }
    }

    ///昇順整列
    haveSkillList.sort((a, b) => a.name.length.compareTo(b.name.length));
    wantSkillList.sort((a, b) => a.name.length.compareTo(b.name.length));

    Map<String, List<RequestUserSkillData>> result = {"haveSkillList": haveSkillList, "wantSkillList": wantSkillList};
    return result;
  }
}
