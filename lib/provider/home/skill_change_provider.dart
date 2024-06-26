import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/skill_change_filter_end_drawer.dart';

class SkillChangeProvider extends ChangeNotifier {
  List<String> filterSkill = [];
  SkillChangeEndDrawerType endDrawerOpenInfo = SkillChangeEndDrawerType.close;

  void changeEndDrawerStatus(SkillChangeEndDrawerType status) {
    endDrawerOpenInfo = status;
    notifyListeners();
  }

  void onChangeSkillFilter(List<String> skillFilter) {
    filterSkill = skillFilter;
    notifyListeners();
  }
}
