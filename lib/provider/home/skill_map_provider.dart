import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import '../../services/skill_service.dart';

class SkillMapProvider extends ChangeNotifier {
  final Map<SkillType, List<SkillModel>> _skillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };
  Map<SkillType, List<SkillModel>> filteredSkillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };
  TextEditingController filterController = TextEditingController();

  Future<void> userSkillList({ProfileData? userData}) async {
    List<RequestSkillListData> requestSkillListData = await SkillService().requestSkillList();

    List<SkillModel> userSkillInfoList = [];

    if (userData != null) {
      ///データベースから資料がレベルに入る
      for (var skill in requestSkillListData) {
        RequestUserSkillData haveSkillItem = userData.mainSkills!.firstWhere((element) => element.name == skill.name,
            orElse: () => RequestUserSkillData(name: skill.name, level: 0, month: 0));
        RequestUserSkillData wantSkillItem = userData.wantSkills!.firstWhere((element) => element.name == skill.name,
            orElse: () => RequestUserSkillData(name: skill.name, level: 0, month: 0));

        SkillModel skillInfo = SkillModel(id: skill.id, skillHave: haveSkillItem, skillWant: wantSkillItem);
        userSkillInfoList.add(skillInfo);
      }
    } else {
      ///データベースから資料がレベルに入る
      for (var skill in requestSkillListData) {
        RequestUserSkillData haveSkillItem = RequestUserSkillData(name: skill.name, level: 0, month: 0);
        RequestUserSkillData wantSkillItem = RequestUserSkillData(name: skill.name, level: 0, month: 0);

        SkillModel skillInfo = SkillModel(id: skill.id, skillHave: haveSkillItem, skillWant: wantSkillItem);
        userSkillInfoList.add(skillInfo);
      }
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
        _skillMap[SkillType.frontend]!.add(skillInfo);
      } else if (backendType.contains(skillName)) {
        ///back
        _skillMap[SkillType.backend]!.add(skillInfo);
      } else if (iotType.contains(skillName)) {
        ///iot
        _skillMap[SkillType.iot]!.add(skillInfo);
      } else {
        ///other
        _skillMap[SkillType.other]!.add(skillInfo);
      }
    }

    filteredSkillMap = _skillMap.map((key, value) {
      return MapEntry(key, value.map((skill) => SkillModel.copy(skill)).toList());
    });
  }

  ///スキル名前でフィルター
  void searchSkillByFilter(String value) {
    filteredSkillMap = _skillMap.map((key, value) {
      return MapEntry(key, value.map((skill) => SkillModel.copy(skill)).toList());
    });

    for (var skillType in SkillType.values) {
      filteredSkillMap[skillType] = filteredSkillMap[skillType]!
          .where(
            (element) => element.skillHave.name.toLowerCase().contains(value),
          )
          .toList();
    }

    notifyListeners();
  }

  ///スキル程度変える
  Map<String, List<RequestUserSkillData>> skillLevelChange(RequestUserSkillData changedSkill, int level) {
    print("skillLevelChange ${changedSkill.name}");
    changedSkill.level = level;
    notifyListeners();
    return typeListToSkill();
  }

  ///スキル程度変える用関数
  Map<String, List<RequestUserSkillData>> typeListToSkill() {
    List<RequestUserSkillData> haveSkillList = [];
    List<RequestUserSkillData> wantSkillList = [];
    for (var e in SkillType.values) {
      for (var ele in filteredSkillMap[e]!) {
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
