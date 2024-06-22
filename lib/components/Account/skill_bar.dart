import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../enum/skill_end_drawer_type.dart';
import '../../models/skill_model.dart';
import '../../provider/home/user_setting_view_provider.dart';
import '../strings/account/sign_up_strings.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

Widget skillSettingTitleBarBtn(SkillEndDrawerType type) {
  return Builder(
    builder: (context) {
      List<RequestUserSkillData> skillData = context.select((UserSettingViewProvider value) => value.haveSkillList);
      if (type != SkillEndDrawerType.haveSkill) {
        skillData = context.select((UserSettingViewProvider value) => value.wantSkillList);
      }
      String btnText = type == SkillEndDrawerType.haveSkill ? StepThirdPage.haveSkillText : StepThirdPage.wantSkillText;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
              userSettingViewProvider.changeEndDrawerStatus(type);
            },
            child: Row(
              children: [
                Text(btnText),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                ),
                Text("(${skillData.length} / 5)"),
              ],
            ),
          ),
          skillBar(type, userSettingProvider: context.read<UserSettingViewProvider>()),
        ],
      );
    },
  );
}

///スキルバー
///param: skillType:表示されてスキルタイプ
/// proivderType: 設定用、userData:表示用
/// courseSkillData:コース用（ある場合はskillTypeがcloseに設定要る）
Widget skillBar(
  SkillEndDrawerType skillType, {
  //スキルデータ
  dynamic userSettingProvider,
  LoginUser? userData,
  List<String>? courseSkillData,
  //スタイル
  double? fontSize,
  Color? backGroundColor,
}) {
  Widget skillBar = Container();
  if (courseSkillData != null) {
    return noLevelSkillContent(
      courseSkillData,
      backGroundColor ?? const Color.fromARGB(255, 236, 157, 120),
      fontSize: fontSize,
    );
  } else if (userSettingProvider == null) {
    skillBar = Builder(builder: (context) {
      List<RequestUserSkillData> skillData = userData!.mainSkills ?? [];
      if (skillType != SkillEndDrawerType.haveSkill) {
        skillData = userData.wantSkills ?? [];
      }

      return skillContent(skillData, backGroundColor ?? googleButtonColor, fontSize: fontSize);
    });
  } else if (userSettingProvider is UserSettingViewProvider) {
    skillBar = Consumer<UserSettingViewProvider>(
      builder: (context, userSettingViewProvider, _) {
        List<RequestUserSkillData> skillData = userSettingViewProvider.haveSkillList;
        if (skillType != SkillEndDrawerType.haveSkill) {
          skillData = userSettingViewProvider.wantSkillList;
        }

        return skillContent(skillData, backGroundColor ?? normalBgColor, fontSize: fontSize);
      },
    );
  }
  return skillBar;
}

Widget noLevelSkillContent(List<String> skillData, Color backGroundColor, {double? fontSize}) {
  return Wrap(
    children: skillData.map((e) {
      return Container(
        margin: const EdgeInsets.only(right: 5, bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: backGroundColor,
        ),
        child: Text(
          e,
          style: TextStyle(color: normalTextColor, fontSize: fontSize ?? 14),
        ),
      );
    }).toList(),
  );
}

Widget skillContent(List<RequestUserSkillData> skillData, Color backGroundColor, {double? fontSize}) {
  var levelIcon = {
    1: Icons.filter_1,
    2: Icons.filter_2,
    3: Icons.filter_3,
    4: Icons.filter_4,
    5: Icons.filter_5,
  };
  return SizedBox(
    width: ScreenSize.width,
    child: skillData.isEmpty
        ? Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(right: 5, bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: backGroundColor,
              ),
              child: Text(
                tr("noskillData"),
                style: TextStyle(color: normalTextColor, fontSize: fontSize ?? 14),
              ),
            ),
          )
        : Wrap(
            children: skillData.map((e) {
              return Container(
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: backGroundColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      levelIcon[e.level],
                      color: normalTextColor,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      e.name,
                      style: TextStyle(color: normalTextColor, fontSize: fontSize ?? 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
  );
}
