import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../models/user_model.dart';
import '../../../enum/route_path.dart';
import '../../../states/friend_state.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';

class SettingButtonInfo {
  String title;
  IconData icon;
  VoidCallback onPress;
  SettingButtonInfo({required this.title, required this.icon, required this.onPress});
}

class UserPage extends StatelessWidget {
  final VoidCallback gotoFriendPage;
  const UserPage({super.key, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = context.watch<UserProvider>().userData;

    FriendState friendState = context.read<FriendState>();

    List<SettingButtonInfo> settingButtonInfoList = [
      SettingButtonInfo(
          title: UserPageString().profileBtn,
          icon: FontAwesomeIcons.solidAddressCard,
          onPress: () {
            Navigator.of(context).pushNamed(
              RoutePath.profilePage.value,
              arguments: userData,
            );
          }),
      SettingButtonInfo(
          title: UserPageString().postBtn,
          icon: FontAwesomeIcons.solidNewspaper,
          onPress: () {
            Navigator.of(context).pushNamed(
              RoutePath.myPosts.value,
              arguments: {
                "userData": userData,
                "gotoFriendPage": gotoFriendPage,
              },
            );
          }),
      SettingButtonInfo(
          title: UserPageString().courseBtn,
          icon: FontAwesomeIcons.school,
          onPress: () {
            print("${UserPageString().courseBtn}");
            Navigator.of(context).pushNamed(RoutePath.myCourses.value, arguments: {
              "userData": userData,
            });
          }),
      SettingButtonInfo(
          title: UserPageString().settingBtn,
          icon: FontAwesomeIcons.gear,
          onPress: () {
            print("${UserPageString().settingBtn}");
            Navigator.of(context).pushNamed(RoutePath.privacySettingPage.value, arguments: {
              "userData": userData,
              "friendState": friendState,
            });
          }),
    ];

    List<SettingButtonInfo> settingButtonInfoList2 = [
      SettingButtonInfo(
          title: UserPageString().friendManagernBtn,
          icon: FontAwesomeIcons.userLarge,
          onPress: () {
            print("${UserPageString().friendManagernBtn}");
            Navigator.of(context).pushNamed(RoutePath.myFriends.value, arguments: {
              "userData": userData,
              "friendState": friendState,
            });
          }),
      SettingButtonInfo(
          title: UserPageString().notificationBtn,
          icon: FontAwesomeIcons.solidBell,
          onPress: () {
            print("${UserPageString().notificationBtn}");
          }),
      SettingButtonInfo(
          title: UserPageString().guideBtn,
          icon: Icons.question_answer,
          onPress: () {
            print("${UserPageString().guideBtn}");
          }),
    ];

    return BackgroundWidget(
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize.safeHeight * 0.05,
          ),
          SizedBox(
            width: ScreenSize.width,
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
          ),
          SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.safeHeight * 0.6,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //持っているスキル
                    Text(StepThirdPage.haveSkillText),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: ScreenSize.width,
                      child: SkillListView(
                        skillList: userData.mainSkills ?? [],
                        backgroundColor: googleColor,
                      ),
                    ),
                    //勉強したいスキル
                    Text(StepThirdPage.wantSkillText),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      width: ScreenSize.width,
                      child: SkillListView(
                        skillList: userData.wantSkills ?? [],
                        backgroundColor: googleColor,
                      ),
                    ),
                    //設定ボタン　例：プロフィール、設定、ニュース...
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: normalBgColor2),
                        borderRadius: BorderRadius.circular(10),
                        color: hintTextColor.withAlpha(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: settingButtonInfoList
                                .map(
                                  (e) => SizedBox(
                                    width: ScreenSize.width / 4,
                                    child: CustomButton(
                                        title: e.title,
                                        icon: e.icon,
                                        titleColor: normalBgColor2,
                                        backgroundColor: normalBgColor,
                                        onPress: e.onPress),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: settingButtonInfoList2
                                .map(
                                  (e) => SizedBox(
                                    width: ScreenSize.width / 4,
                                    child: CustomButton(
                                        title: e.title,
                                        icon: e.icon,
                                        titleColor: normalBgColor2,
                                        backgroundColor: normalBgColor,
                                        onPress: e.onPress),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
