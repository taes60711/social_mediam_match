import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';

import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:web_socket_channel/io.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';

class ChatRoom extends StatelessWidget {
  GlobalKey<ScaffoldState> globalKey;
  final LoginUser? userData;
  ChatRoom({super.key, required this.globalKey, this.userData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    IOWebSocketChannel chatRoomChannel = IOWebSocketChannel.connect(channelRoomUrl);
    TextEditingController messageInput = TextEditingController();

    List<dynamic> members = [];
    return SizedBox(
      width: ScreenSize().width,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: StatefulWrapper(
            onInit: () async {
              await chatRoomChannel.ready;
              chatRoomChannel.sink.add('{"method" : "connect" , "roomid" : ${friendFuture.roomId}}');
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () async {
                      print("Drawer Close");
                      chatRoomChannel.sink.close();
                      globalKey.currentState!.closeEndDrawer();
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: chatRoomChannel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String data = snapshot.data;
                          List<dynamic> messageData = jsonDecode(data)['Message'];
                          members = jsonDecode(data)["Members"];
                          return ListView.builder(
                            itemCount: messageData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Align(
                                  alignment:
                                      userData!.uid == messageData[index]["userId"] ? Alignment.topRight : Alignment.topLeft,
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
                          );
                        } else {
                          return Loading();
                        }
                      }),
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
                        chatRoomChannel.sink.add(
                            '{"method" : "sendMessage" , "roomid" : ${friendFuture.roomId} , "userid" : ${userData!.uid} , "message" : ${messageInput.text}}');
                        friendFuture.friendListChannel.sink.add('{"method" : "sendMessage" , "members" : $members}');
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
            )),
      ),
    );
  }
}
