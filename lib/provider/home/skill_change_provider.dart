import 'package:flutter/material.dart';

class SkillChangeProvider extends ChangeNotifier {
  List<String> filterSkill = [];

  void onChangeSkillFilter(List<String> skillFilter) {
    filterSkill = skillFilter;
    notifyListeners();
  }
}
