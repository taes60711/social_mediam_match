List<String> frontType = [
  "javascript",
  "typescript",
  "css",
  "html",
  "Vue.js",
  "React",
  "AndroidStudio",
  "Flutter",
  "objective-c",
  "Angular"
];
List<String> iotType = [
  "Arduino",
  "C",
  "C++",
];
List<String> backendType = [
  "Java",
  "Python",
  "MySQL",
];

///dataType
enum SkillType {
  frontend("前端", 0),
  backend("後端", 1),
  iot("韌體", 2),
  other("語言", 3);

  final String value;
  final int type;
  const SkillType(this.value, this.type);
}
