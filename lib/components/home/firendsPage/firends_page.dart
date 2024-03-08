// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:social_mediam_match/global.dart';
// import 'package:web_socket_channel/io.dart';

// class Firends extends StatefulWidget {
//   const Firends({super.key});

//   @override
//   State<Firends> createState() => _FirendsState();
// }

// class _FirendsState extends State<Firends> {
//   IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://$ip:123/ws');
//   IOWebSocketChannel? channel1;
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   bool isSendMessage = false;
//   String JsonData = "";
//   int roomIndex = -1;
//   @override
//   void initState() {
//     super.initState();
//     _initializeConnection();
//   }

//   void _initializeConnection() async {
//     await channel.ready;
//     channel.sink.add('{"method" : "connect" , "userid" : "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2"}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController messageInput = TextEditingController();
//     Widget drawerPage() {
//       return Drawer(
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(0),
//           ),
//         ),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 onPressed: () async {
//                   print("Drawer Close");
//                   roomIndex = -1;
//                   await channel1?.sink.close();
//                   _key.currentState!.closeEndDrawer();
//                 },
//                 icon: const Icon(Icons.arrow_back_ios_sharp),
//               ),
//             ),
//             const Text("聊天室"),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: JsonData != "" ? jsonDecode(JsonData)["Message"].length : 0,
//                   itemBuilder: (context, index) {
//                     List<dynamic> messageData = jsonDecode(JsonData)["Message"];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         color: Colors.lime,
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 color: Colors.deepPurple,
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("使用者:${messageData[index]["userId"].toString().substring(0, 5)}"),
//                                 Text("${messageData[index]["message"]}"),
//                                 Text("${messageData[index]["sentAt"].toString().substring(0, 10)}"),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Container(
//                       height: 30,
//                       child: TextField(
//                         controller: messageInput,
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.only(top: 5, left: 10),
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter Message',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     channel1?.sink.add(
//                         '{"method" : "sendMessage" , "roomid" : ${roomIndex} , "userid" : "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2" , "message" : ${messageInput.text}}');
//                     setState(() {
//                       isSendMessage = true;
//                     });
//                   },
//                   child: Container(
//                     width: 80,
//                     height: 30,
//                     color: Colors.deepOrange,
//                     child: const Center(
//                       child: Text("傳送訊息"),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     }

//     return StreamBuilder(
//       stream: channel.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           String data = snapshot.data;
//           List<dynamic> jsonData = jsonDecode(data);
//           return Scaffold(
//             key: _key,
//             endDrawer: drawerPage(),
//             body: Column(
//               children: [
//                 const Text("列表"),
//                 Expanded(
//                   child: ListView.builder(
//                       itemCount: jsonData.length,
//                       itemBuilder: ((context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                             onTap: () async {
//                               channel1 = IOWebSocketChannel.connect('ws://$ip:123/ws/chatroom');
//                               await channel1?.ready;
//                               roomIndex = jsonData[index]["roomId"];
//                               channel1?.sink.add('{"method" : "connect" , "roomid" : ${jsonData[index]["roomId"]}}');
//                               channel1?.stream.listen((event) {
//                                 print("channel1 message : " + event);
//                                 setState(() {
//                                   JsonData = event;
//                                 });
//                                 if (isSendMessage) {
//                                   channel.sink.add('{"method" : "sendMessage" , "members" : ${jsonDecode(JsonData)["Members"]}}');
//                                   setState(() {
//                                     isSendMessage = false;
//                                   });
//                                 }
//                               });
//                               _key.currentState!.openEndDrawer();
//                             },
//                             child: Container(
//                               color: Colors.indigoAccent,
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       width: 50,
//                                       height: 50,
//                                       color: Colors.pinkAccent,
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("${jsonData[index]["roomName"]}"),
//                                       jsonData[index]["lastMessage"] != null
//                                           ? Text(
//                                               "${jsonData[index]["lastMessage"]}",
//                                               style: TextStyle(color: Colors.black54),
//                                             )
//                                           : const Text(""),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       })),
//                 ),
//               ],
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/require_login.dart';
import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
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
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    Widget userComponent;

    if (userData != null) {
      userComponent = Builder(builder: (context) {
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
                      return GestureDetector(
                        onTap: () async {
                          friendFuture.openRoom(jsonData[index]['roomId']);
                          _key.currentState!.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: const Color.fromARGB(255, 197, 171, 161),
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
