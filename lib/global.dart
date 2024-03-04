// ip
String ip = "114.37.133.37";
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
