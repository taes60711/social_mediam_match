import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import '../../../models/user_model.dart';

class FirendsPage extends StatelessWidget {
  final LoginUser userData;
  const FirendsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    List<FriendListModel> friendList = context.watch<FriendState>().friendList;
    GlobalKey<ScaffoldState> key = context.select((FriendState value) => value.key);
    LoginUser ohterUserData = context.select((FriendState value) => value.ohterUserData);

    print("firendPage");

    return Scaffold(
        body: Scaffold(
      key: key,
      endDrawer: ChatRoom(
        globalKey: key,
        ohterUserData: ohterUserData,
        userData: userData,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const TabBar(
              tabs: [
                Tab(text: '全部'),
                Tab(text: '好友'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  const Text("全部列表"),
                  Expanded(
                    child: friendList.length == 0
                        ? const Center(
                            child: Text("Nodata"),
                          )
                        : ListView.builder(
                            itemCount: friendList.length,
                            itemBuilder: (context, index) {
                              FriendListModel listInfo = friendList[index];
                              LoginUser userData = listInfo.userData;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    friendFuture.openRoom(friendList[index].roomId, userData);
                                    key.currentState!.openEndDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: UserIcon(
                                            iconSize: 50,
                                            image: userData.image,
                                          )),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(userData.name ?? userData.email),
                                          friendList[index].lastMessage != null
                                              ? Text(
                                                  "${friendList[index].lastMessage}",
                                                  style: const TextStyle(color: Colors.black54),
                                                )
                                              : const Text(""),
                                        ],
                                      ),
                                    ],
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
                        ? const Center(
                            child: Text("Nodata"),
                          )
                        : ListView.builder(
                            itemCount: friendList.length,
                            itemBuilder: (context, index) {
                              FriendListModel listInfo = friendList[index];
                              LoginUser userData = listInfo.userData;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    friendFuture.openRoom(listInfo.roomId, userData);
                                    key.currentState!.openEndDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: UserIcon(
                                            iconSize: 50,
                                            image: userData.image,
                                          )),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(userData.name ?? userData.email),
                                          listInfo.lastMessage != null
                                              ? Text(
                                                  "${listInfo.lastMessage}",
                                                  style: const TextStyle(color: Colors.black54),
                                                )
                                              : const Text(""),
                                        ],
                                      ),
                                    ],
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
