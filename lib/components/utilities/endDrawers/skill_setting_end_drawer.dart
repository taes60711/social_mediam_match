// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../provider/home/user_setting_view_provider.dart';
// import '../../account/skill_choice_setting_page.dart';

// enum SkillEndDrawerType {
//   haveSkill,
//   wantSkill,
//   close;
// }

// ///MARK: void スキル設定ページ開くように
// void openSkillSettingEndDrawer({required BuildContext context, required SkillEndDrawerType type}) {
//   context.read<UserSettingViewProvider>().changeEndDrawerStatus(type);
// }

// ///MARK: void スキル設定ページ閉じるように
// void closeSkillSettingEndDrawer({required BuildContext context}) {
//   context.read<UserSettingViewProvider>().changeEndDrawerStatus(SkillEndDrawerType.close);
// }

// ///MARK: widget スキル設定ページ用EndDrawer
// Widget skillSettingEndDrawer() {
//   return Builder(builder: (context) {
//     print("skillSettingEndDrawer");
//     SkillEndDrawerType endDrawer = context.select((UserSettingViewProvider value) => value.endDrawerOpenInfo);

//     Widget endDrawerWidget = Container();

//     if (endDrawer == SkillEndDrawerType.haveSkill) {
//       endDrawerWidget = SkillChoiceSettingPage(
//         skillType: SkillEndDrawerType.haveSkill,
//         onDismissedFunc: () => closeSkillSettingEndDrawer(context: context),
//       );
//     } else if (endDrawer == SkillEndDrawerType.wantSkill) {
//       endDrawerWidget = SkillChoiceSettingPage(
//         skillType: SkillEndDrawerType.wantSkill,
//         onDismissedFunc: () => closeSkillSettingEndDrawer(context: context),
//       );
//     }

//     return endDrawerWidget;
//   });
// }
