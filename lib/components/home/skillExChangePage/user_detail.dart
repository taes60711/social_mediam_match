import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../states/friend_state.dart';
import '../../../states/skill_exchange_state.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/skill_list_view.dart';

class UserDetail extends StatelessWidget {
  final LoginUser? userData;
  final GlobalKey<ScaffoldState> globalKey;
  const UserDetail({super.key, required this.globalKey, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    LoginUser otherUser = context.select((SkillExChangeState value) =>
        value.otherUser ?? LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0));
    bool isFriend = context.select((FriendState value) => value.isFriend);

    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [userData!.uid, otherUser.uid];
        friendFuture.checkIsFriend(usersList);
      },
      child: SizedBox(
        width: ScreenSize().width,
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
                    friendFuture.UserDetailPageClose(userData!.uid);
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                ),
              ),
              UserIcon(
                iconSize: 100,
                image: otherUser.image,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("名前 : ${otherUser.name ?? otherUser.email}"),
                    Text("身分: ${otherUser.status}"),
                    Text("自我介紹 : ${otherUser.introduction ?? ""}"),
                    Text("最後登入時間: ${otherUser.lastLogin}"),
                    SizedBox(
                      width: ScreenSize().width,
                      child: SkillListView(
                        title: skillText,
                        skillList: userData!.mainSkills ?? [],
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize().width,
                      child: SkillListView(
                        title: wantSkillText,
                        skillList: userData!.wantSkills ?? [],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  List<String> usersList = [userData!.uid, otherUser.uid];
                  friendFuture.addFriend(usersList);
                },
                child: isFriend ? Text("已是好友") : Text("新增好友"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
