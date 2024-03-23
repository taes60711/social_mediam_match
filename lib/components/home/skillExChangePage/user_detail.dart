import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../states/friend_state.dart';
import '../../../states/skill_exchange_state.dart';

class UserDetail extends StatelessWidget {
  final LoginUser? userData;
  final GlobalKey<ScaffoldState> globalKey;
  const UserDetail({super.key, required this.globalKey, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    LoginUser otherUser = context.select((SkillExChangeState value) =>
        value.otherUser ?? LoginUser(uid: "", lastLogin: "", email: "", isEmailVerified: false, status: 0));
    String friendListMessage = context.select((FriendState value) => value.friendListMessage);
    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [userData!.uid, otherUser.uid];
        friendFuture.checkIsFriend(usersList);
        if (friendListMessage == "is already Friend") {
          print("is already Friend");
        }
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
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                color: Colors.deepOrangeAccent,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("名前 : ${otherUser.name ?? otherUser.email}"),
                    Text("自我介紹 : ${otherUser.introduction ?? ""}"),
                    Text("最後登入時間: ${otherUser.lastLogin}"),
                    Text("擅長的技能: ${otherUser.mainSkills!.map((e) => e.name).toList()}"),
                    Text("擅長的技能程度: ${otherUser.mainSkills!.map((e) => e.level).toList()}"),
                    Text("想學的技能: ${otherUser.wantSkills!.map((e) => e.name).toList()}"),
                    Text("想學的技能程度: ${otherUser.wantSkills!.map((e) => e.level).toList()}"),
                    Text("身分: ${otherUser.status}")
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  List<String> usersList = [userData!.uid, otherUser.uid];
                  friendFuture.addFriend(usersList);
                },
                child: Text("新增好友"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
