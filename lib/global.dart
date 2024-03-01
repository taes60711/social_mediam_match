String ip = "114.37.137.216";
String port = '80';

enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp");

  final String value;
  const RoutePath(this.value);
}
