List<String> frontType = [
  "React",
  "Vue",
  "Angular",
  "Next",
  "Nuxt",
  "Qwik",
  "Bootstrap",
  "Html",
  "Css",
  "Svelte",
  "WordPress",
  "ReactNative",
  "Flutter",
  "Swift",
  "Android studio",
  "Firebase"
];
List<String> backendType = [
  "Flask",
  "Django",
  "FastAPI",
  "ASP .NET Core",
  "Laravel",
  "Ruby on Rails",
  "ExpressJS",
  "Spring Boot"
];
List<String> iotType = ["STM", "Arduino", "Raspberry Pi", "8051", "ARM"];
List<String> programLanguageType = [
  "C",
  "C++",
  "C#",
  "Java",
  "TypeScript",
  "JavaScript",
  "PHP",
  "Node.js",
  "Python",
  "Matlab",
  "Shell Script"
];

List<String> cloudType = ["GCP", "AWS", "Azure"];

///dataType
enum SkillType {
  frontend("前端", 0),
  backend("後端", 1),
  iot("韌體", 2),
  cloud("雲端", 3),
  programLanguage("程式語言", 4),
  other("語言", 5);

  final String value;
  final int type;
  const SkillType(this.value, this.type);
}
