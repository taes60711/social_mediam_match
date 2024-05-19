import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';

class ChatRoom extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser userData;
  final LoginUser ohterUserData;
  const ChatRoom({super.key, required this.globalKey, required this.userData, required this.ohterUserData});

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    bool isLoading = context.select((FriendState value) => value.isLoading);
    List<ChatRoomMessageModel> messageData = context.select((FriendState value) => value.chatRoomMesaage);
    int roomId = context.select((FriendState value) => value.roomId);
    TextEditingController messageInput = context.select((FriendState value) => value.messageInput);

    //例: ["2024-04-20",ChatRoomMessageModel,"2024-05-03",ChatRoomMessageModel...]
    List<dynamic> ss = [];
    //true的時候要顯示使用者圖像
    bool test = true;
    for (int i = 0; i < messageData.length; i++) {
      //index : 0 - last比較
      // 防止range over 問題
      if (i < messageData.length - 1) {
        DateTime now = DateTime.now().toUtc();
        String formattedTime = DateFormat("yyyy-MM-dd ").format(now.toLocal());
        //index 0 先insert時間
        if (i == 0) {
          if (formattedTime == messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length)) {
            ss.add("今日");
          } else {
            ss.add(messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length));
          }
        }
        //i 與 i + 1 的 message時間不同時 ||  i 與 i + 1 的使用者不同時
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length) !=
                messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length) ||
            messageData[i].userId != messageData[i + 1].userId) {
          //這邊的 needAppearImg 應該都要為 false
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: messageData[i].sentAt,
              needAppearImg: test));
          // 當下一筆資料為不同使用者或是時間不同時 要顯示頭像 才讓boolean變為true
          test = true;
        } else {
          //這邊的 needAppearImg 應該都要為 true
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId, message: messageData[i].message, sentAt: "", needAppearImg: test));
          //當下一筆資料為同使用者和時間相同 不要顯示頭像 才讓boolean變為false
          test = false;
        }
        //i 與 i + 1 的 message時間 不同時insert 時間
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length) !=
            messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length)) {
          if (formattedTime == messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length)) {
            ss.add("今日");
          } else {
            ss.add(messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length));
          }
        }
        //index : index last - last -1 比較
      } else {
        //當最後一筆資料 與 最後前一筆資料進行比對 時間不同或使用者不同時 顯示頭像
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length) !=
                messageData[i - 1].sentAt.substring(0, "yyyy-MM-dd ".length) ||
            messageData[i].userId != messageData[i - 1].userId) {
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: messageData[i].sentAt,
              needAppearImg: true));
        } else {
          //當最後一筆資料 與 最後前一筆資料進行比對 時間和使用者相同時 不顯示頭像
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: messageData[i].sentAt,
              needAppearImg: false));
        }
      }
    }

    return StatefulWrapper(
      onInit: () {
        Future.delayed(Duration(milliseconds: 300)).then((value) => friendFuture.initialRoomListener(roomId));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          height: ScreenSize().height,
          width: ScreenSize().width,
          child: Column(
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
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                width: ScreenSize().width,
                color: normalBgColor,
                child: Row(
                  children: [
                    UserIcon(
                      iconSize: 35,
                      image: ohterUserData.image,
                    ),
                    SizedBox(width: 10),
                    Text(ohterUserData.name ?? ohterUserData.email),
                  ],
                ),
              ),
              Expanded(
                child: !isLoading
                    ? LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35)
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: const NoLoadingCustomBouncingScrollPhysics(),
                              itemCount: ss.length,
                              itemBuilder: (context, index) {
                                Widget component;
                                if (ss[index].runtimeType == String) {
                                  component = Center(
                                    child: Container(
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          ss[index],
                                          style: TextStyle(fontSize: 10),
                                        )),
                                  );
                                } else if (ss[index].runtimeType == ChatRoomMessageModel) {
                                  if (ss[index].userId == userData.uid) {
                                    component = Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            ss[index].sentAt != "" ? ss[index].sentAt.substring("yyyy-MM-dd ".length) : "",
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
                                                child: Text(ss[index].message),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 3),
                                            child: ss[index].needAppearImg
                                                ? UserIcon(
                                                    iconSize: 35,
                                                    image: userData.image,
                                                  )
                                                : Container(width: 35),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    component = Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 3),
                                            child: ss[index].needAppearImg
                                                ? UserIcon(
                                                    iconSize: 35,
                                                    image: ohterUserData.image,
                                                  )
                                                : Container(width: 35),
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
                                                child: Text(ss[index].message),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ss[index].sentAt != "" ? ss[index].sentAt.substring("yyyy-MM-dd ".length) : "",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  component = Container();
                                }
                                return component;
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
