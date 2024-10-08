import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/skill_change_filter_end_drawer.dart';

import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';

class SkillChangeProvider extends ChangeNotifier {
  List<RequestSkillListData> filteredSkill = [];
  SkillChangeEndDrawerType endDrawerOpenInfo = SkillChangeEndDrawerType.close;

  final Map<SkillType, List<RequestSkillListData>> skillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  Future<void> getFilterList(List<RequestSkillListData> requestSkillListData) async {
    for (var skillInfo in requestSkillListData) {
      String skillName = skillInfo.name;
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

  void changeEndDrawerStatus(SkillChangeEndDrawerType status) {
    endDrawerOpenInfo = status;
    notifyListeners();
  }

  void onChangeSkillFilter(RequestSkillListData choicedSkill) {
    if (filteredSkill.any((element) => element == choicedSkill)) {
      filteredSkill.remove(choicedSkill);
    } else {
      filteredSkill.add(choicedSkill);
    }
    notifyListeners();
  }
}
