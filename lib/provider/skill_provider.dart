import 'package:flutter/material.dart';
import 'package:social_mediam_match/enum/skill_type.dart';

import '../models/skill_model.dart';
import '../states/services/skill_service.dart';

class SkillProvider extends ChangeNotifier {
  Map<SkillType, List<String>> skillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  ///スキルが種類より加工する
  Future<void> getSkillTypeMap() async {
    List<RequestSkillListData> requestSkillListData = await SkillService().requestSkillList();
    for (var e in requestSkillListData) {
      if (frontType.contains(e.name)) {
        ///front
        skillMap[SkillType.frontend]!.add(e.name);
      } else if (backendType.contains(e.name)) {
        ///back
        skillMap[SkillType.backend]!.add(e.name);
      } else if (iotType.contains(e.name)) {
        ///iot
        skillMap[SkillType.iot]!.add(e.name);
      } else {
        ///other
        skillMap[SkillType.other]!.add(e.name);
      }
    }
    notifyListeners();
  }
}
