import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/require_login.dart';
import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import '../../../models/user_model.dart';

class FirendsPage extends StatelessWidget {
  final LoginUser? userData;
  const FirendsPage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    String friendListMessage = context.select((FriendState value) => value.friendListMessage);
    GlobalKey<ScaffoldState> _key = context.select((FriendState value) => value.key);

    Widget userComponent;

    if (userData != null) {
      userComponent = Builder(builder: (context) {
        print("object");
        if (friendListMessage != "") {
          List<dynamic> jsonData = jsonDecode(friendListMessage);
          return Scaffold(
            key: _key,
            endDrawer: ChatRoom(
              globalKey: _key,
              userData: userData,
            ),
            body: Column(
              children: [
                const Text("好友列表"),
                Expanded(
                  child: ListView.builder(
                    itemCount: jsonData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            friendFuture.openRoom(jsonData[index]['roomId']);
                            _key.currentState!.openEndDrawer();
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
                                  Text("${jsonData[index]["roomName"]}"),
                                  jsonData[index]["lastMessage"] != null
                                      ? Text(
                                          "${jsonData[index]["lastMessage"]}",
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
          );
        } else {
          return const Loading();
        }
      });
    } else {
      userComponent = const requireLogin();
    }

    return Scaffold(body: userComponent);
  }
}
