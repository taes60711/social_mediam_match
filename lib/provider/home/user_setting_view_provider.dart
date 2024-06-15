import 'package:flutter/material.dart';

import '../../models/skill_model.dart';

class UserSettingViewProvider extends ChangeNotifier {
  TextEditingController nameInput = TextEditingController();
  TextEditingController jobInput = TextEditingController();
  TextEditingController introductionInput = TextEditingController();

  List<RequestUserSkillData> haveSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];

  void changeSkillList(Map<String, List<RequestUserSkillData>> skillData) {
    haveSkillList = skillData["haveSkillList"]!;
    wantSkillList = skillData["wantSkillList"]!;
    notifyListeners();
  }

  void inputOnChange(String value) {
    introductionInput.text = value;
    notifyListeners();
  }
}
