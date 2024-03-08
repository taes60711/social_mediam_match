import 'package:social_mediam_match/models/user_model.dart';

class SkillModel {
  int id;
  ProfileSkill skillHave;
  ProfileSkill skillWant;

  SkillModel({required this.id, required this.skillHave, required this.skillWant});
}

class ProfileSkill {
  SkillInfo skillInfo;
  bool ishave;
  ProfileSkill({required this.skillInfo, required this.ishave});
}
