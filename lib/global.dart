// ip
// 之後須改放在setting file
String ip = "114.37.137.216";
String port = '80';

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),
  profilePage("/profile");

  final String value;
  const RoutePath(this.value);
}
