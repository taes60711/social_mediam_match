String signOutButton = "登出";
String skillText = "能教的技能";
String wantSkillText = "想學的技能";

enum ManagerButton {
  profile(
    "個人資料",
  ),
  post("我的文章"),
  // classes("我的課程"),
  friend("好友管理"),
  set("設定");

  final String value;
  const ManagerButton(this.value);
}
