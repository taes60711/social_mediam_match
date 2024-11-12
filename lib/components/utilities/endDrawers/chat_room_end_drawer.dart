// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/provider/friend_provider.dart';

// import '../../home/firendsPage/chat_room.dart';
// import 'base_end_drawer.dart';

// enum ChatRoomEndDrawerType {
//   open,
//   close;
// }

// ///Before use need ParentWidget Create FriendProvider

// ///MARK: void チャットルームページ開くように
// void openChatRoomEndDrawer({required BuildContext context}) {
//   context.read<FriendProvider>().changeChatRoomEndDrawerStatus(ChatRoomEndDrawerType.open);
// }

// ///MARK: void チャットルームページ開くように
// void closecChatRoomEndDrawer({required BuildContext context}) {
//   context.read<FriendProvider>().changeChatRoomEndDrawerStatus(ChatRoomEndDrawerType.close);
// }

// ///MARK: Widget チャットルームページ用EndDrawer
// Widget chatRoomEndDrawer() {
//   return Builder(
//     builder: (context) {
//       print("courseDetailEndDrawer");
//       ChatRoomEndDrawerType endDrawer = context.select((FriendProvider value) => value.chatRoomEndDrawerOpenInfo);

//       Widget endDrawerWidget = Container();

//       if (endDrawer == ChatRoomEndDrawerType.open) {
//         endDrawerWidget = EndDrawer(
//           isNeedTopbar: false,
//           onDismissed: () {
//             closecChatRoomEndDrawer(context: context);
//           },

//           /// チャットルームページ
//           child: ChatRoom(),
//         );
//       }

//       return endDrawerWidget;
//     },
//   );
// }
