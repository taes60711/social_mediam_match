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
  frontend("前端"),
  backend("後端"),
  iot("韌體"),
  other("語言");

  final String value;
  const SkillType(this.value);
}
