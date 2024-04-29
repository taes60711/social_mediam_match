import 'package:easy_localization/easy_localization.dart';

class SignUpError {
  String emailFormatError = tr("su_error_invalid-email");
  String pwdWeakError = tr("su_error_weak-pwd");
  String noError = "";
}

//signup_first_page
class FirstPage {
  String title = tr("su_fp_title");
  String introduction = tr("su_fp_introduction");
  String emailInputTitle = tr("su_fp_emailInputTitle");
  String emailButtonText = tr("su_fp_emailButtonText");
  String googleButtonText = tr("su_fp_googleButtonText");
  String twitterButtonText = tr("su_fp_twitterButtonText");
  String hintText = tr("su_fp_hintText");
  String termText = tr("su_fp_termText");
  String privacyText = tr("su_fp_privacyText");
  String andText = tr("su_fp_andText");
  String orText = tr("su_fp_orText");
}

//signup_step_one
class StepOnePage {
  String title = tr("su_st_one_p_title");
  String nameInputTitle = tr("su_st_one_p_nameInputTitle");
  String pwdInputTitle = tr("su_st_one_p_pwdInputTitle");
  String signUpButtonText = tr("su_st_one_p_signUpButtonText");
}

//signup_step_two
class StepTwoPage {
  String title = tr("su_st_two_p_title");
  String jobInputTitle = tr("su_st_two_p_jobInputTitle");
  String introInputTitle = tr("su_st_two_p_introInputTitle");
  String haveSkillText = tr("su_st_two_p_haveSkill");
  String wantSkillText = tr("su_st_two_p_wantSkill");
  String sendButtonText = tr("su_st_two_p_sentButtonText");
}

//signup_guide
class StepGuide {
  String title = "導覽";
}
