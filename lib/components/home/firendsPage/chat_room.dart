import 'package:any_link_preview/any_link_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/friend_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';
import '../../utilities/loading.dart';

class ChatRoom extends StatelessWidget {
  final LoginUser userData;
  final LoginUser ohterUserData;
  ChatRoom({super.key, required this.userData, required this.ohterUserData});

  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    bool isLoading = context.select((FriendState value) => value.isLoading);
    List<ChatRoomMessageModel> messageData = context.watch<FriendState>().chatRoomMesaage;
    int pageNumber = context.select((FriendState value) => value.pageNumber);
    int pageCount = context.select((FriendState value) => value.pageCount);
    int roomId = context.select((FriendState value) => value.roomId);
    TextEditingController messageInput = context.select((FriendState value) => value.messageInput);
    bool isDataAddLoding = context.select((FriendState value) => value.isDataAddLoding);

    //例: ["2024-04-20",ChatRoomMessageModel,"2024-05-03",ChatRoomMessageModel...]
    List<dynamic> ss = [];
    //true的時候要顯示使用者圖像
    bool test = true;
    for (int i = 0; i < messageData.length; i++) {
      DateTime now = DateTime.now().toUtc();
      String formattedTime = DateFormat("yyyy-MM-dd ").format(now.toLocal());
      //index : 0 - last比較
      // 防止range over 問題
      if (i < messageData.length - 1) {
        //i 與 i + 1 的 message時間不同時 ||  i 與 i + 1 的使用者不同時
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length) !=
                messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length) ||
            messageData[i].userId != messageData[i + 1].userId) {
          //這邊的 needAppearImg 應該都要為 false
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: test ? messageData[i].sentAt : "",
              needAppearImg: true));
          // 當下一筆資料為不同使用者或是時間不同時 要顯示頭像 才讓boolean變為true
          test = true;
        } else {
          //這邊的 needAppearImg 應該都要為 true
          ss.add(ChatRoomMessageModel(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: test ? messageData[i].sentAt : "",
              needAppearImg: false));
          //當下一筆資料為同使用者和時間相同 不要顯示頭像 才讓boolean變為false
          test = false;
        }
        //i 與 i + 1 的 message時間 不同時insert 時間
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length) !=
            messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd ".length)) {
          if (formattedTime == messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length)) {
            ss.add("今日");
          } else {
            ss.add(messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length));
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
              userId: messageData[i].userId, message: messageData[i].message, sentAt: "", needAppearImg: true));
        }
        //最後一筆補上日期
        if (formattedTime == messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length)) {
          ss.add("今日");
        } else {
          ss.add(messageData[i].sentAt.substring(0, "yyyy-MM-dd ".length));
        }
      }
    }

    Widget dataAddLoading = Container();
    if (isDataAddLoding) {
      if (pageCount > pageNumber) {
        dataAddLoading = const Padding(padding: EdgeInsets.all(10), child: Loading());
      } else {
        dataAddLoading = Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(FontAwesomeIcons.commentSlash, color: normalBgColor),
                Text(
                  "沒有資訊",
                  style: TextStyle(color: normalBgColor),
                )
              ],
            ));
      }
    }

    return StatefulWrapper(
      onInit: () {
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          friendFuture.initialRoomListener(roomId, userData.uid);
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              width: ScreenSize().width,
              color: normalBgColor2.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print("Chat Room close");
                        friendFuture.closeRoom(context: context);
                      },
                      child: Icon(Icons.arrow_back_ios_sharp, color: normalBgColor2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: UserIcon(
                        iconSize: 35,
                        image: ohterUserData.image,
                      ),
                    ),
                    Text(
                      ohterUserData.name ?? ohterUserData.email,
                      style: TextStyle(color: normalBgColor2),
                    ),
                  ],
                ),
              ),
            ),
            dataAddLoading,
            Expanded(
              child: isLoading
                  ? LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35)
                  : Align(
                      alignment: Alignment.topCenter,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            final scrollPosition = scrollNotification.metrics.pixels;
                            final max = scrollNotification.metrics.maxScrollExtent;
                            if (scrollPosition >= max && !isDataAddLoding) {
                              friendFuture.dataAddLoadingChange(true);
                            }
                          } else if (scrollNotification is ScrollEndNotification) {
                            if (isDataAddLoding) {
                              friendFuture.loadMessage(roomId, userData.uid, pageNumber);
                            }
                          }
                          return false;
                        },
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const ChatRoomCustomBouncingScrollPhysics(),
                          controller: _scrollController,
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
                              ChatRoomMessageModel messageData = ss[index];
                              List<String> splitStringAndUrls(String input) {
                                final urlPattern = RegExp(r'https?://\S+');
                                List<String> parts = [];
                                int start = 0;

                                for (final match in urlPattern.allMatches(input)) {
                                  if (match.start > start) {
                                    parts.add(input.substring(start, match.start));
                                  }
                                  parts.add(match.group(0)!);
                                  start = match.end;
                                }

                                if (start < input.length) {
                                  parts.add(input.substring(start));
                                }

                                return parts;
                              }

                              List<String> messageContents = splitStringAndUrls(messageData.message);

                              String firstUrl = messageContents.firstWhere((element) {
                                return element.contains('https');
                              }, orElse: () => "-1");
                              if (ss[index].userId == userData.uid) {
                                component = Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            messageData.sentAt != "" ? messageData.sentAt.substring("yyyy-MM-dd ".length) : "",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Color.fromARGB(255, 200, 199, 202),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxWidth: ScreenSize().width * 0.6,
                                                        ),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: messageContents.map((e) {
                                                              if (e.startsWith('https')) {
                                                                return TextSpan(
                                                                    text: e,
                                                                    style: TextStyle(
                                                                        color: googleColor, decoration: TextDecoration.underline),
                                                                    recognizer: TapGestureRecognizer()
                                                                      ..onTap = () {
                                                                        final Uri _url = Uri.parse(e);
                                                                        launchUrl(_url);
                                                                      });
                                                              } else {
                                                                return TextSpan(text: e, style: TextStyle(color: Colors.black));
                                                              }
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                firstUrl != "-1"
                                                    ? Container(
                                                        margin: EdgeInsets.only(top: 2),
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Color.fromARGB(255, 200, 199, 202),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 8),
                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                                maxWidth: ScreenSize().width * 0.6, maxHeight: 160),
                                                            child: AnyLinkPreview(
                                                              link: firstUrl,
                                                              titleStyle: TextStyle(fontSize: 14),
                                                              backgroundColor: Colors.transparent,
                                                              boxShadow: [BoxShadow(color: Colors.transparent)],
                                                              bodyStyle: TextStyle(color: normalTextColor, fontSize: 12),
                                                              borderRadius: 0,
                                                              bodyMaxLines: 2,
                                                            ),
                                                          ),
                                                        ))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 3),
                                        child: messageData.needAppearImg
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 3),
                                        child: messageData.needAppearImg
                                            ? UserIcon(
                                                iconSize: 35,
                                                image: ohterUserData.image,
                                              )
                                            : Container(width: 35),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: const Color.fromARGB(255, 196, 175, 233),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Column(
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            maxWidth: ScreenSize().width * 0.6,
                                                          ),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: messageContents.map((e) {
                                                                if (e.startsWith('https')) {
                                                                  return TextSpan(
                                                                      text: e,
                                                                      style: TextStyle(
                                                                          color: googleColor,
                                                                          decoration: TextDecoration.underline),
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap = () {
                                                                          final Uri _url = Uri.parse(e);
                                                                          launchUrl(_url);
                                                                        });
                                                                } else {
                                                                  return TextSpan(text: e, style: TextStyle(color: Colors.black));
                                                                }
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                firstUrl != "-1"
                                                    ? Container(
                                                        margin: EdgeInsets.only(top: 2),
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: const Color.fromARGB(255, 196, 175, 233),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 8),
                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                                maxWidth: ScreenSize().width * 0.6, maxHeight: 160),
                                                            child: AnyLinkPreview(
                                                              link: firstUrl,
                                                              titleStyle: TextStyle(fontSize: 14),
                                                              backgroundColor: Colors.transparent,
                                                              boxShadow: [BoxShadow(color: Colors.transparent)],
                                                              bodyStyle: TextStyle(color: normalTextColor, fontSize: 12),
                                                              borderRadius: 0,
                                                              bodyMaxLines: 2,
                                                            ),
                                                          ),
                                                        ))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            messageData.sentAt != "" ? messageData.sentAt.substring("yyyy-MM-dd ".length) : "",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
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
                    ),
            ),
            Container(
              width: ScreenSize().width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
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
                  GestureDetector(
                    onTap: () {
                      friendFuture.sendMessage(roomId, userData.uid, messageInput.text);
                      _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    child: Container(
                      height: 30,
                      margin: EdgeInsets.only(left: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: normalBgColor2.withOpacity(0.5)),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          size: 16,
                          color: normalTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
