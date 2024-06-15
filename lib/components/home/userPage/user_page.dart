import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/skill_bar.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/enum/skill_type.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../models/user_model.dart';
import '../../../pagemanager/setting/route_manager.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.safeHeight * 0.05),
          userInfo(context),
          skillInfoWithPage(context),
        ],
      ),
    );
  }
}

Widget skillInfoWithPage(BuildContext context) {
  return FitWidget(
    height: ScreenSize.safeHeight * 0.6,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          //持っているスキル
          Text(StepThirdPage.haveSkillText),
          skillBar(SignUpEndDrawerType.haveSkill, proivderType: context.read<UserProvider>()),

          //勉強したいスキル
          Text(StepThirdPage.wantSkillText),
          skillBar(SignUpEndDrawerType.wantSkill, proivderType: context.read<UserProvider>()),

          const SizedBox(height: 10),
          //設定ボタン　例：プロフィール、設定、ニュース...
          Container(
            width: ScreenSize.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: normalBgColor2),
              borderRadius: BorderRadius.circular(10),
              color: hintTextColor.withAlpha(25),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: UserPageRouthsettingButtonInfo.list
                  .map(
                    (e) => CustomButton(
                      title: e.title,
                      icon: e.icon,
                      titleColor: normalBgColor2,
                      backgroundColor: normalBgColor,
                      onPress: e.onPress,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userInfo(BuildContext context) {
  LoginUser userData = context.watch<UserProvider>().userData;
  return SizedBox(
    height: ScreenSize.safeHeight * 0.3,
    child: FittedBox(
      child: Column(
        children: [
          UserIcon(iconSize: 100, image: userData.image),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Hello, ${userData.name ?? userData.email}"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: hintTextColor.withAlpha(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${UserPageString().infoStatus} : ${userData.status}"),
                Text("${UserPageString().infoJob} : ${userData.job}"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
