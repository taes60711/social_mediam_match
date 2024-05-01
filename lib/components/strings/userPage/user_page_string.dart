import 'package:easy_localization/easy_localization.dart';

String signOutButton = "登出";
String skillText = "能教的技能";
String wantSkillText = "想學的技能";

enum ManagerButton {
  profile("個人資料"),
  post("我的文章"),
  friend("好友管理"),
  notification("通知"),
  guide("導覽"),
  set("設定");

  final String value;
  const ManagerButton(this.value);
}

class ProfileString {
  String title = tr("profile_title");
  String nameInputTitle = tr("profile_nameInputTitle");
  String jobInputTitle = tr("profile_jobInputTitle");
  String introductionInputTitle = tr("profile_introductionInputTitle");
  String imgPickerButtonText = tr("profile_imgPickerButtonText");
  String updateButtonText = tr("profile_updateButtonText");
}
