import 'package:easy_localization/easy_localization.dart';

class SignUpError {
  static String emailFormatError = tr("su_error_invalid-email");
  static String pwdWeakError = tr("su_error_weak-pwd");
  static String noError = "";
}

//signup_first_page
class StepOnePage {
  static String title = tr("su_fp_title");
  static String introduction = tr("su_fp_introduction");
  static String emailInputTitle = tr("su_fp_emailInputTitle");
  static String emailButtonText = tr("su_fp_emailButtonText");
  static String googleButtonText = tr("su_fp_googleButtonText");
  static String twitterButtonText = tr("su_fp_twitterButtonText");
  static String hintText = tr("su_fp_hintText");
  static String termText = tr("su_fp_termText");
  static String privacyText = tr("su_fp_privacyText");
  static String andText = tr("su_fp_andText");
  static String orText = tr("su_fp_orText");
}

//signup_step_one
class StepTwoPage {
  static String title = tr("su_st_one_p_title");
  static String nameInputTitle = tr("su_st_one_p_nameInputTitle");
  static String pwdInputTitle = tr("su_st_one_p_pwdInputTitle");
  static String signUpButtonText = tr("su_st_one_p_signUpButtonText");
}

//signup_step_two
class StepThirdPage {
  static String title = tr("su_st_two_p_title");
  static String jobInputTitle = tr("su_st_two_p_jobInputTitle");
  static String introInputTitle = tr("su_st_two_p_introInputTitle");
  static String haveSkillText = tr("su_st_two_p_haveSkill");
  static String wantSkillText = tr("su_st_two_p_wantSkill");
  static String sendButtonText = tr("su_st_two_p_sentButtonText");
}

//signup_guide
class StepGuide {
  static String title = "導覽";
  static String skipButtonText = "跳過";
}
