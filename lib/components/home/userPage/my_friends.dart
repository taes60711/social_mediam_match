import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';

import '../../../global.dart';
import '../../../models/friend_model.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class MyFriends extends StatelessWidget {
  const MyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    List<FriendListModel> friendList = context.watch<FriendState>().friendList;

    Future<void> deleteFriendCheck({required List<String> members, required int roomId}) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('確定要刪除好友?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('確定'),
                onPressed: () {
                  friendFuture.deleteFriend(members, roomId);
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: ScreenSize().width * 0.33,
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              SizedBox(width: ScreenSize().width * 0.33, child: const Center(child: Text("我的好友"))),
            ],
          ),
          Expanded(
            child: ListView.builder(
              physics: const NoLoadingCustomBouncingScrollPhysics(),
              itemCount: friendList.length,
              itemBuilder: (context, index) {
                FriendListModel listInfo = friendList[index];
                LoginUser otherUserData = listInfo.userData;
                return Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.1, color: normalBgColor2))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UserIcon(
                                iconSize: 50,
                                image: otherUserData.image,
                              )),
                          SizedBox(
                            width: ScreenSize().width - 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(otherUserData.name ?? otherUserData.email)),
                                    IconButton(
                                      onPressed: () {
                                        deleteFriendCheck(roomId: listInfo.roomId, members: [listInfo.memberId]);
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
