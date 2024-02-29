String ip = "61.228.189.249";
String port = '80';

enum Path {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp");

  final String value;
  const Path(this.value);
}
