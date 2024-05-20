import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import '../../../models/user_model.dart';
import '../../utilities/custom_end_drawer.dart';

class FirendsPage extends StatelessWidget {
  final LoginUser userData;
  const FirendsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    List<FriendListModel> friendList = context.watch<FriendState>().friendList;

    Future<void> opneChatRoomPage({required LoginUser loginUser, required LoginUser choicedRoomUser}) {
      return showDialog(
        context: context,
        useSafeArea: false,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
        builder: (BuildContext context) {
          return CustomEndDrawer(
            child: Dismissible(
              direction: DismissDirection.startToEnd,
              resizeDuration: const Duration(milliseconds: 1),
              onDismissed: (_) {
                friendFuture.closeRoom(context: context);
                print("Chat Room close");
              },
              key: const Key('key'),
              child: ChatRoom(
                ohterUserData: choicedRoomUser,
                userData: loginUser,
              ),
            ),
          );
        },
      );
    }

    print("firendPage ");

    return Scaffold(
        body: Scaffold(
      key: key,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: const [
              SizedBox(
                height: 25,
                child: Tab(text: '全部'),
              ),
              SizedBox(
                height: 25,
                child: Tab(text: '好友'),
              ),
            ],
            isScrollable: true,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 1.0, color: normalBgColor),
              insets: const EdgeInsets.symmetric(horizontal: 10),
            ),
            labelPadding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            labelColor: normalBgColor2,
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  const Text("全部列表"),
                  Expanded(
                    child: friendList.length == 0
                        ? SizedBox(
                            height: ScreenSize().height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Icon(
                                    FontAwesomeIcons.usersSlash,
                                    color: normalBgColor2,
                                    size: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                                  child: Text(
                                    "目前沒有好友",
                                    style: TextStyle(color: normalBgColor2),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: friendList.length,
                            itemBuilder: (context, index) {
                              FriendListModel listInfo = friendList[index];
                              LoginUser otherUserData = listInfo.userData;
                              return Container(
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.1, color: normalBgColor2))),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      friendFuture.openRoom(friendList[index].roomId);
                                      await opneChatRoomPage(loginUser: userData, choicedRoomUser: friendList[index].userData);
                                    },
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
                                                    friendList[index].sentAt != null
                                                        ? Text(
                                                            "${friendList[index].sentAt}",
                                                            style: TextStyle(fontSize: 12, color: normalBgColor2),
                                                          )
                                                        : const Text(""),
                                                  ],
                                                ),
                                                friendList[index].lastMessage != null
                                                    ? Text(
                                                        "${friendList[index].lastMessage}",
                                                        style: const TextStyle(color: Colors.black54),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                    : const Text(
                                                        "沒有任何訊息",
                                                        style: TextStyle(color: Colors.black54),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("好友列表"),
                  Expanded(
                    child: friendList.length == 0
                        ? SizedBox(
                            height: ScreenSize().height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Icon(
                                    FontAwesomeIcons.usersSlash,
                                    color: normalBgColor2,
                                    size: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                                  child: Text(
                                    "目前沒有好友",
                                    style: TextStyle(color: normalBgColor2),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: friendList.length,
                            itemBuilder: (context, index) {
                              FriendListModel listInfo = friendList[index];
                              LoginUser otherUserData = listInfo.userData;
                              return Container(
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.1, color: normalBgColor2))),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      friendFuture.openRoom(friendList[index].roomId);
                                      await opneChatRoomPage(loginUser: userData, choicedRoomUser: friendList[index].userData);
                                    },
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
                                                    friendList[index].sentAt != null
                                                        ? Text(
                                                            "${friendList[index].sentAt}",
                                                            style: TextStyle(fontSize: 12, color: normalBgColor2),
                                                          )
                                                        : const Text(""),
                                                  ],
                                                ),
                                                friendList[index].lastMessage != null
                                                    ? Text(
                                                        "${friendList[index].lastMessage}",
                                                        style: const TextStyle(color: Colors.black54),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                    : const Text(
                                                        "沒有任何訊息",
                                                        style: TextStyle(color: Colors.black54),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
