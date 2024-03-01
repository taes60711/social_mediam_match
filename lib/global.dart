//ip // 放在setting file
String ip = "114.37.137.216";
String port = '80';

//AES加密
String aesKey = "0L47WiOu+89XPg1iZhsXxkaesoB0JLPA";
String aesIV = "O0leTlHp5xGAxZEv";

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp");

  final String value;
  const RoutePath(this.value);
}
