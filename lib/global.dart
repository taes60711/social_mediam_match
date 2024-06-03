// ip
String ip = "114.37.105.252";
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

List<String> forntType = ["javascript", "typescript", "css", "html", "vue", "React", "AndroidStudio", "Flutter", "objective-c"];
List<String> iotType = ["arduino"];
List<String> backendType = ["java", "python", "mysql"];

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),
  profilePage("/profile"),
  postEditPage("/postEdit"),
  courseEditPage("/courseEdit"),
  skillChoicePage("/skillChoice"),
  myPosts("/myposts"),
  myCourses("/mycourses"),
  myFriends("/myFriends"),
  privacySettingPage("/privacySetting");

  final String value;
  const RoutePath(this.value);
}
