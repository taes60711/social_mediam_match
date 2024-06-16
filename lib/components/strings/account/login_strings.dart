import 'package:easy_localization/easy_localization.dart';

class LoginError {
  static String emailFormatError = tr("login_error_invalid-email");
  static String emailorPwdError = tr("login_invalid-credential");
  static String noError = "";
}

class Login {
  static String emailInputTitle = tr("login_emailInputTitle");
  static String pwdInputTitle = tr("login_pwdInputTitle");
  static String forgotPassword = tr("login_pwdForgot");
  static String emailLoginButtonText = tr("login_emailButtonText");
  static String signUpButtonText = tr("login_singUpButtonText");
  static String googleButtonText = tr("login_googleButtonText");
  static String twitterButtonText = tr("login_twitterButtonText");
}

class PasswordForgot {
  static String emailInputTitle = tr("pwdForgot_emailInputTitle");
  static String sendButtonText = tr("pwdForgot_sendButtonText");
}
