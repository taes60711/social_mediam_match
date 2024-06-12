List<String> frontType = ["javascript", "typescript", "css", "html", "vue", "React", "AndroidStudio", "Flutter", "objective-c"];
List<String> iotType = ["arduino"];
List<String> backendType = ["java", "python", "mysql"];

///dataType
enum SkillType {
  frontend("前端"),
  backend("後端"),
  iot("韌體"),
  other("其他");

  final String value;
  const SkillType(this.value);
}

enum SkillChoicePageType {
  have,
  want;
}

enum SignUpEndDrawerType {
  haveSkill,
  wantSkill,
  close;
}
