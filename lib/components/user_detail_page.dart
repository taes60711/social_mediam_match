import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';

import '../enum/skill_end_drawer_type.dart';

import '../models/user_model.dart';
import '../pageManager/setting/route_controller.dart';

import '../pageManager/enum/bottom_bar_path.dart';
import '../pageManager/setting/bottom_bar_controller_provider.dart';
import '../provider/account/user_provider.dart';
import '../provider/friend_provider.dart';
import 'account/skill_bar.dart';
import 'strings/account/sign_up_strings.dart';
import 'utilities/user_icon.dart';

class UserDetailPage extends StatelessWidget {
  final LoginUser otherUser;
  final Function? toChatRoom;
  const UserDetailPage({super.key, required this.otherUser, this.toChatRoom});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [context.watch<UserProvider>().userData.uid, otherUser.uid];
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
                Text("名前 : ${otherUser.name ?? otherUser.email}"),
                Text("身分: ${otherUser.status}"),
                Text("自我介紹 : ${otherUser.introduction ?? ""}"),
                Text("最後登入時間: ${otherUser.lastLogin}${tr("skExChpage_beforDays")}"),
                Text(StepThirdPage.haveSkillText),
                skillBar(SkillEndDrawerType.haveSkill, userData: otherUser),
                Text(StepThirdPage.wantSkillText),
                skillBar(SkillEndDrawerType.wantSkill, userData: otherUser),
              ],
            ),
            Visibility(
              visible: otherUser.uid != context.watch<UserProvider>().userData.uid,
              child: Builder(
                builder: (context) {
                  bool isFriend = context.select((FriendProvider value) => value.isFriend);
                  return isFriend
                      ? ElevatedButton(
                          onPressed: () {
                            toChatRoom!() ?? () {};
                            RouteOptions.popUntilToHome();
                            context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom);
                          },
                          child: Text("開啟聊天室"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            List<String> usersList = [context.watch<UserProvider>().userData.uid, otherUser.uid];
                            context.read<FriendProvider>().addFriend(usersList);
                          },
                          child: Text("新增好友"),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
