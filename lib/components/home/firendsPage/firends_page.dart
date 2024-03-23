import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import '../../../models/user_model.dart';

class FirendsPage extends StatelessWidget {
  final LoginUser userData;
  const FirendsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    String friendListMessage = context.select((FriendState value) => value.friendListMessage);
    GlobalKey<ScaffoldState> key = context.select((FriendState value) => value.key);

    Widget userComponent;

    print("UserPage");
    userComponent = Builder(builder: (context) {
      if (friendListMessage != "" && friendListMessage != "is already Friend") {
        List<FriendListModel> data = (jsonDecode(friendListMessage) as List<dynamic>).map((e) {
          return FriendListModel.fromJson(e);
        }).toList();

        return Scaffold(
          key: key,
          endDrawer: ChatRoom(
            globalKey: key,
            userData: userData,
          ),
          body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const TabBar(
                  tabs: [
                    Tab(text: '全部'),
                    Tab(text: '好友'),
                    Tab(text: '群組'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Column(
                    children: [
                      const Text("全部列表"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  friendFuture.openRoom(data[index].roomId);
                                  key.currentState!.openEndDrawer();
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].roomName),
                                        data[index].lastMessage != null
                                            ? Text(
                                                "${data[index].lastMessage}",
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
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return data[index].roomType == 1
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        friendFuture.openRoom(data[index].roomId);
                                        key.currentState!.openEndDrawer();
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.pinkAccent,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data[index].roomName),
                                              data[index].lastMessage != null
                                                  ? Text(
                                                      "${data[index].lastMessage}",
                                                      style: const TextStyle(color: Colors.black54),
                                                    )
                                                  : const Text(""),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("群組列表"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return data[index].roomType == 2
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        friendFuture.openRoom(data[index].roomId);
                                        key.currentState!.openEndDrawer();
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.pinkAccent,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data[index].roomName),
                                              data[index].lastMessage != null
                                                  ? Text(
                                                      "${data[index].lastMessage}",
                                                      style: const TextStyle(color: Colors.black54),
                                                    )
                                                  : const Text(""),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return const Loading();
      }
    });

    return Scaffold(body: userComponent);
  }
}
