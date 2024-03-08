String pageTitle = "個人資料";
String level = "程度 : ";

String updateButtonTitle = "更新";

enum ItemTitles {
  username("用戶名", hintText: "用戶名"),
  selfIntroduction("自我介紹", hintText: "Write a message "),
  Skill("擅長的技能"),
  wantSkill("想要學的技能");

  final String value;
  final String? hintText;
  const ItemTitles(this.value, {this.hintText});
}

enum SkillType {
  forntend("前端"),
  backend("後端"),
  iot("韌體"),
  other("其他");

  final String value;
  const SkillType(this.value);
}

var items = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
];
