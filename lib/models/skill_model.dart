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

  RequestSkillListData({required this.name, required this.id});

  RequestSkillListData.copy(RequestSkillListData skillListData)
      : id = skillListData.id,
        name = skillListData.name;

  RequestSkillListData copy() {
    return RequestSkillListData(
      id: id,
      name: name,
    );
  }

  factory RequestSkillListData.toModel(Map<String, dynamic> json) {
    return RequestSkillListData(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RequestUserSkillData {
  String name;
  int level;
  int month;

  RequestUserSkillData({required this.name, required this.level, required this.month});

  factory RequestUserSkillData.empty() {
    return RequestUserSkillData(
      name: "",
      level: 0,
      month: 0,
    );
  }

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

  RequestUserSkillData copy() {
    return RequestUserSkillData(
      name: name,
      level: level,
      month: month,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'month': month,
    };
  }
}
