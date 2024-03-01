// ip
// 之後須改放在setting file
String ip = "114.37.137.216";
String port = '80';

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp");

  final String value;
  const RoutePath(this.value);
}

//import 'package:encrypt/encrypt.dart' as encrypt;

// //AES加密
// String aesKey = "0L47WiOu+89XPg1iZhsXxkaesoB0JLPA";
// String aesIV = "O0leTlHp5xGAxZEv";

// //加密
// final key = encrypt.Key.fromUtf8(aesKey);
// final iv = encrypt.IV.fromUtf8(aesIV);
// final encrypter = encrypt.Encrypter(encrypt.AES(key));
// final encrypted = encrypter.encrypt(password, iv: iv);
// print(encrypted.base64);

// // 解密
// final encrypters = encrypt.Encrypter(encrypt.AES(key));
// String s = "jzXPDhqma8EuBofE3jCTpA==";
// final decrypteds = encrypters.decryptBytes(encrypt.Encrypted.fromBase64(s), iv: iv);
// final decryptedData = utf8.decode(decrypteds);
// print(decryptedData);
