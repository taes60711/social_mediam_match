String pageTitle = "個人資料";
String level = "程度 : ";
List<String> ItemTitles = ["用戶名", "自我介紹", "擅長的技能", "想要學的技能"];
String updateButtonTitle = "更新";

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
