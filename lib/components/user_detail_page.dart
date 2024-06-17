import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/enum/user_detail_end_drawer_type.dart';

import '../models/user_model.dart';
import '../pageManager/setting/route_controller.dart';

import '../pageManager/enum/bottom_bar_path.dart';
import '../pageManager/setting/bottom_bar_controller_provider.dart';
import '../provider/account/user_provider.dart';
import '../provider/friend_provider.dart';

class UserDetailPage extends StatelessWidget {
  final LoginUser otherUser;
  const UserDetailPage({super.key, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        List<String> usersList = [context.watch<UserProvider>().userData.uid, otherUser.uid];
        context.read<FriendProvider>().checkIsFriend(usersList);
      },
      child: Scaffold(
        body: Column(
          children: [
            BaseTopBar(
              backFunc: () {
                context.read<FriendProvider>().changeEndDrawerStatus(UserDetailEndDrawerType.close, otherUser);
              },
            ),
            Builder(builder: (context) {
              bool isFriend = context.select((FriendProvider value) => value.isFriend);
              return isFriend
                  ? ElevatedButton(
                      onPressed: () {
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
            }),
          ],
        ),
      ),
    );
  }
}
