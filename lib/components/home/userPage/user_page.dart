import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/skill_bar.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../models/user_model.dart';

import '../../../pageManager/enum/route_path.dart';
import '../../../pageManager/setting/route_controller.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
import '../../utilities/style/screen_size.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: _mainBody(context),
    );
  }
}

Widget _mainBody(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: ScreenSize.safeHeight * 0.05),
      userInfo(context),
      skillInfoWithPage(context),
    ],
  );
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
          skillBar(
            SkillEndDrawerType.haveSkill,
            userData: context.read<UserProvider>().userData,
          ),

          //勉強したいスキル
          Text(StepThirdPage.wantSkillText),
          skillBar(
            SkillEndDrawerType.wantSkill,
            userData: context.read<UserProvider>().userData,
          ),

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
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: UserPageRouthsettingButtonInfo.list
                  .map(
                    (e) => UserPageString().notificationBtn == e.title
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              ColIconBtn(
                                icon: e.icon,
                                title: e.title,
                                onPress: e.onPress,
                              ),

                              ///通知数
                              Visibility(
                                visible: context.watch<UserProvider>().notReadNotificationCount != "0",
                                child: Positioned(
                                  right: 25,
                                  top: 0,
                                  child: Builder(builder: (context) {
                                    return Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.watch<UserProvider>().notReadNotificationCount,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          )
                        : ColIconBtn(
                            icon: e.icon,
                            title: e.title,
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

class SettingButtonInfo {
  String title;
  IconData icon;
  VoidCallback onPress;
  SettingButtonInfo({required this.title, required this.icon, required this.onPress});
}

class UserPageRouthsettingButtonInfo {
  static List<SettingButtonInfo> list = [
    SettingButtonInfo(
      title: UserPageString().profileBtn,
      icon: FontAwesomeIcons.solidAddressCard,
      onPress: () => RouteOptions.pushTo(RoutePath.profilePage),
    ),
    SettingButtonInfo(
        title: UserPageString().postBtn,
        icon: FontAwesomeIcons.solidNewspaper,
        onPress: () {
          RouteOptions.pushTo(RoutePath.myPosts);
        }),
    SettingButtonInfo(
        title: UserPageString().courseBtn,
        icon: FontAwesomeIcons.school,
        onPress: () {
          RouteOptions.pushTo(RoutePath.myCourses);
        }),
    SettingButtonInfo(
        title: UserPageString().settingBtn,
        icon: FontAwesomeIcons.gear,
        onPress: () {
          RouteOptions.pushTo(RoutePath.privacySettingPage);
        }),
    SettingButtonInfo(
        title: UserPageString().friendManagernBtn,
        icon: FontAwesomeIcons.userLarge,
        onPress: () {
          RouteOptions.pushTo(RoutePath.myFriends);
        }),
    SettingButtonInfo(
        title: UserPageString().notificationBtn,
        icon: FontAwesomeIcons.solidBell,
        onPress: () {
          RouteOptions.pushTo(RoutePath.myNotifictaionPage);
        }),
    SettingButtonInfo(
        title: UserPageString().customServiceBtn,
        icon: Icons.question_answer,
        onPress: () {
          RouteOptions.pushTo(RoutePath.customServicePage);
        }),
  ];
}
