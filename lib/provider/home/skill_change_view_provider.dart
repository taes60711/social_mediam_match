import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/skill_change_filter_end_drawer.dart';

import '../../models/skill_model.dart';

class SkillChangeProvider extends ChangeNotifier {
  List<String> filteredSkill = [];
  SkillChangeEndDrawerType endDrawerOpenInfo = SkillChangeEndDrawerType.close;
  List<String> skillList = [];

  Future<void> getFilterList(List<RequestSkillListData> requestSkillListData) async {
    for (var element in requestSkillListData) {
      skillList.add(element.name);
    }
    notifyListeners();
  }

  void changeEndDrawerStatus(SkillChangeEndDrawerType status) {
    endDrawerOpenInfo = status;
    notifyListeners();
  }

  void onChangeSkillFilter(String choicedSkill) {
    if (filteredSkill.any((element) => element == choicedSkill)) {
      filteredSkill.remove(choicedSkill);
    } else {
      filteredSkill.add(choicedSkill);
    }
    notifyListeners();
  }
}
