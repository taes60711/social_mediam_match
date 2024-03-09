import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';

class ChatRoom extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser? userData;
  const ChatRoom({super.key, required this.globalKey, this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    String chatRoomMessage = context.select((FriendState value) => value.chatRoomMesaage);
    TextEditingController messageInput = TextEditingController();
    int roomId = context.select((FriendState value) => value.roomId);

    return SizedBox(
      width: ScreenSize().width,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (chatRoomMessage != "") {
              List<dynamic> messageData = jsonDecode(chatRoomMessage)['Message'];
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () async {
                        print("Drawer Close");
                        friendFuture.closeRoom();
                        globalKey.currentState!.closeEndDrawer();
                      },
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: messageData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: userData!.uid == messageData[index]["userId"] ? Alignment.topRight : Alignment.topLeft,
                            child: Container(
                              color: Colors.deepPurple,
                              child: Column(
                                crossAxisAlignment: userData!.uid == messageData[index]["userId"]
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text("使用者:${messageData[index]["userId"].toString().substring(0, 6)}"),
                                  Text("${messageData[index]["message"]}"),
                                  Text(messageData[index]["sentAt"].toString().substring(0, 10)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: messageInput,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 5, left: 10),
                                border: OutlineInputBorder(),
                                hintText: 'Enter Message',
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          friendFuture.sendMessage(roomId, userData!.uid, messageInput.text);
                        },
                        child: Container(
                          width: 80,
                          height: 30,
                          color: Colors.deepOrange,
                          child: const Center(
                            child: Text("傳送訊息"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return const Loading();
            }
          },
        ),
      ),
    );
  }
}
