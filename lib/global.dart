// ip
String ip = "114.37.115.77";
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),
  profilePage("/profile");

  final String value;
  const RoutePath(this.value);
}
