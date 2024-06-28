import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../pageManager/setting/bottom_bar_controller_provider.dart';
import '../../../provider/friend_provider.dart';

import '../../account/skill_bar.dart';
import '../../utilities/endDrawers/skill_setting_end_drawer.dart';

class UserDetail extends StatelessWidget {
  final LoginUser? otherUser;
  final GlobalKey<ScaffoldState> globalKey;

  const UserDetail({super.key, required this.globalKey, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    FriendProvider friendFuture = context.read<FriendProvider>();
    LoginUser userData = context.watch<UserProvider>().userData;
    LoginUser realOtherUser = otherUser ?? LoginUser();
    bool isFriend = context.select((FriendProvider value) => value.isFriend);

    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [userData.uid, realOtherUser.uid];
        friendFuture.checkIsFriend(usersList);
      },
      child: SizedBox(
        width: ScreenSize.width,
        child: Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () async {
                    print("Drawer Close");
                    globalKey.currentState!.closeEndDrawer();
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                ),
              ),
              UserIcon(
                iconSize: 100,
                image: realOtherUser.image,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${tr("user_nickName")} : ${realOtherUser.name ?? realOtherUser.email}"),
                    Text("${tr("user_status")} : ${realOtherUser.status}"),
                    Text("${tr("user_introduction")}  : ${realOtherUser.introduction ?? ""}"),
                    Text("${tr("user_lastLogin_time")} : ${realOtherUser.lastLogin}"),
                    SizedBox(
                      width: ScreenSize.width,
                      child: skillBar(
                        SkillEndDrawerType.haveSkill,
                        userData: realOtherUser,
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize.width,
                      child: skillBar(
                        SkillEndDrawerType.wantSkill,
                        userData: realOtherUser,
                      ),
                    ),
                  ],
                ),
              ),
              isFriend
                  ? ElevatedButton(
                      onPressed: () {
                        RouteOptions.popUntilToHome();
                        context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom);
                      },
                      child: Text(tr("toChatRoom")),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        List<String> usersList = [userData.uid, realOtherUser.uid];
                        friendFuture.addFriend(usersList);
                      },
                      child: Text(tr("addFriend")),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
