class SkillModel {
  int id;
  RequestUserSkillData skillHave;
  RequestUserSkillData skillWant;

  SkillModel({required this.id, required this.skillHave, required this.skillWant});

  SkillModel.copy(SkillModel skill)
      : id = skill.id,
        skillHave = RequestUserSkillData.copy(skill.skillHave),
        skillWant = RequestUserSkillData.copy(skill.skillWant);
}

class RequestSkillListData {
  String name;
  int id;
  // 画面用
  bool isChoiced;

  RequestSkillListData({required this.name, required this.id, this.isChoiced = false});

  RequestSkillListData.copy(RequestSkillListData skillListData)
      : id = skillListData.id,
        name = skillListData.name,
        isChoiced = false;

  factory RequestSkillListData.toModel(Map<String, dynamic> json) {
    return RequestSkillListData(
      id: json["id"],
      name: json["name"],
    );
  }
}

class RequestUserSkillData {
  String name;
  int level;
  int month;

  RequestUserSkillData({required this.name, required this.level, required this.month});
  RequestUserSkillData.copy(RequestUserSkillData data)
      : name = data.name,
        level = data.level,
        month = data.month;

  factory RequestUserSkillData.fromMap(Map<String, dynamic> json) {
    return RequestUserSkillData(
      name: json["name"],
      level: json["level"],
      month: json["month"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
      'month': month,
    };
  }
}
