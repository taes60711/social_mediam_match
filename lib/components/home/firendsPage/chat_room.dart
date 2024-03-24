import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';

class ChatRoom extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser userData;
  const ChatRoom({super.key, required this.globalKey, required this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    String chatRoomMessage = context.select((FriendState value) => value.chatRoomMesaage);
    int roomId = context.select((FriendState value) => value.roomId);
    TextEditingController messageInput = context.select((FriendState value) => value.messageInput);

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
              List<ChatRoomMessageModel> messageData = (jsonDecode(chatRoomMessage)['Message'] as List<dynamic>).map((e) {
                return ChatRoomMessageModel.fromJson(e);
              }).toList();
              inspect(messageData);
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
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 8,
                            ),
                            child: userData.uid == messageData[index].userId
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        messageData[index].sentAt,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color.fromARGB(255, 200, 199, 202),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            child: Text(messageData[index].message),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 3),
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: Color.fromARGB(255, 117, 64, 223),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: const Color.fromARGB(255, 196, 175, 233),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            child: Text(messageData[index].message),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        messageData[index].sentAt,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ));
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
                          friendFuture.sendMessage(roomId, userData.uid, messageInput.text);
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
