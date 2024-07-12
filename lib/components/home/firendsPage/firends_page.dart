import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import 'package:social_mediam_match/provider/friend_provider.dart';
import '../../../models/user_model.dart';
import '../../utilities/endDrawers/chat_room_end_drawer.dart';

class FirendsPage extends StatelessWidget {
  const FirendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              searchBar(context),
              Builder(builder: (context) {
                TextEditingController friendListFilterInput =
                    context.select((FriendProvider value) => value.friendListFilterInput);
                List<FriendListModel> filteredList = context.watch<FriendProvider>().friendList.where((element) {
                  bool filterRequest = true;
                  if (friendListFilterInput.text != "") {
                    filterRequest = element.userData.email.contains(friendListFilterInput.text);
                    if (element.userData.name != null) {
                      filterRequest = element.userData.name!.contains(friendListFilterInput.text);
                    }
                  }
                  return filterRequest;
                }).toList();
                return Expanded(
                  child: filteredList.isEmpty
                      ? noDataWidget()
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            FriendListModel listInfo = filteredList[index];
                            LoginUser otherUserData = listInfo.userData;
                            return Container(
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.1, color: normalBgColor2))),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    context.read<FriendProvider>().openRoom(listInfo.roomId, listInfo.userData);
                                    openChatRoomEndDrawer(context: context);
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
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Row(
                                                  children: [
                                                    Expanded(child: Text(otherUserData.name ?? otherUserData.email)),
                                                    listInfo.sentAt != null
                                                        ? Text(
                                                            "${listInfo.sentAt}",
                                                            style: TextStyle(fontSize: 12, color: normalBgColor2),
                                                          )
                                                        : const Text(""),
                                                  ],
                                                ),
                                              ),
                                              listInfo.lastMessage != null
                                                  ? Text(
                                                      listInfo.lastMessage!.contains("http://\$ip")
                                                          ? "傳送了圖像"
                                                          : "${listInfo.lastMessage}",
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
                );
              }),
            ],
          ),
          chatRoomEndDrawer(),
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    TextEditingController friendListFilterInput = context.select((FriendProvider value) => value.friendListFilterInput);
    return Container(
      margin: const EdgeInsets.all(10),
      width: ScreenSize.width,
      height: 36,
      child: TextField(
        cursorColor: normalBgColor2,
        controller: friendListFilterInput,
        decoration: InputDecoration(
          hintText: "Search By name",
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          contentPadding: const EdgeInsets.all(8),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          context.read<FriendProvider>().friendListFilterInputOnChange(value);
        },
      ),
    );
  }

  Widget noDataWidget() {
    return SizedBox(
      height: ScreenSize.height,
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
    );
  }
}
