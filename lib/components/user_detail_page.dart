import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../models/user_model.dart';
import '../pageManager/setting/route_controller.dart';

import '../provider/account/user_provider.dart';
import '../provider/friend_provider.dart';
import 'account/skill_bar.dart';
import 'strings/account/sign_up_strings.dart';
import 'utilities/endDrawers/skill_setting_end_drawer.dart';
import 'utilities/user_icon.dart';

class UserDetailPage extends StatelessWidget {
  final ProfileData otherUser;
  final Function? toChatRoom;
  const UserDetailPage({super.key, required this.otherUser, this.toChatRoom});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [context.read<UserProvider>().userData.uid, otherUser.uid];

        context.read<FriendProvider>().checkIsFriend(usersList);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            UserIcon(
              iconSize: 100,
              image: otherUser.image,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${tr("user_nickName")} : ${otherUser.name ?? otherUser.email}"),
                Text("${tr("user_status")} : ${otherUser.status}"),
                Text("${tr("user_introduction")} : ${otherUser.introduction ?? ""}"),
                Text("${tr("user_lastLogin_time")} : ${otherUser.lastLogin}${tr("skExChpage_beforDays")}"),
                Text(StepThirdPage.haveSkillText),
                skillBar(SkillEndDrawerType.haveSkill, userData: otherUser),
                Text(StepThirdPage.wantSkillText),
                skillBar(SkillEndDrawerType.wantSkill, userData: otherUser),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: otherUser.uid != context.read<UserProvider>().userData.uid,
              child: Builder(
                builder: (context) {
                  bool isFriend = context.select((FriendProvider value) => value.isFriend);
                  return isFriend
                      ? TextBtn(
                          title: tr("toChatRoom"),
                          titleColor: normalTextColor,
                          btnColor: normalBgColor.withOpacity(0.9),
                          btnWidth: 100,
                          verticalMargin: 8,
                          onPress: () {
                            toChatRoom!() ?? () {};
                            RouteOptions.popUntilToHome();
                            // context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom);
                          })
                      : TextBtn(
                          title: tr("addFriend"),
                          titleColor: normalTextColor,
                          btnColor: normalBgColor.withOpacity(0.9),
                          btnWidth: 100,
                          verticalMargin: 8,
                          onPress: () {
                            List<String> usersList = [context.read<UserProvider>().userData.uid, otherUser.uid];
                            context.read<FriendProvider>().addFriend(usersList);
                          });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
