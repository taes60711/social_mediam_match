// ip
String ip = "114.37.142.48";
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

List<String> forntType = ["javascript", "typescript", "css", "html", "vue", "React", "AndroidStudio", "Flutter", "objective-c"];
List<String> iotType = ["arduino"];
List<String> backendType = ["java", "python", "mysql"];

enum SkillType {
  forntend("前端"),
  backend("後端"),
  iot("韌體"),
  other("其他");

  final String value;
  const SkillType(this.value);
}

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),
  profilePage("/profile"),
  postEditPage("/postEdit"),
  skillChoicePage("/skillChoice"),
  PrivacySettingPage("/privacySetting");

  final String value;
  const RoutePath(this.value);
}
