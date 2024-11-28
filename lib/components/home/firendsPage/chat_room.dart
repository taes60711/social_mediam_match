import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:social_mediam_match/components/home/firendsPage/comment_build.dart';
import 'package:social_mediam_match/components/utilities/appBar/chat_room_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/enum/date_format_utilities.dart';

import 'package:social_mediam_match/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/friend_model.dart';

import '../../../models/rich_text_format.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/friend/chat_room_ws_model.dart';

import '../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import 'package:any_link_preview/any_link_preview.dart';

class ChatRoom extends BaseEndDrawer {
  FriendListModel roomData;
  int dataIndex;
  ChatRoom({required this.roomData, required this.dataIndex});

  ChatRoomWSModel chatRoomWSModel = ChatRoomWSModel();

  List formattedRoomMsg = [];
  final _scrollController = ScrollController();
  bool addData = false;

  @override
  Future<void> initState(WidgetRef ref) async {
    ProfileData myUserData = ref.watch(loginUserData);
    chatRoomWSModel.init(ref, () => render(), userId: myUserData.uid, roomId: roomData.roomId);
  }

  @override
  Future<void> dispose(WidgetRef ref) async {
    chatRoomWSModel.closeRoom();
  }

  @override
  Widget build(WidgetRef ref) {
    List<ChatRoomMsg> roomMsg = ref.read(roomMessageProvider.notifier).state.chatRoomMsg;

    formattedRoomMsg = formatChatMsg(roomMsg);

    formattedRoomMsg = formattedRoomMsg.reversed.toList();
    return CommonScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              userBar(),
              Visibility(visible: addData, child: const Loading()),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      final scrollPosition = scrollNotification.metrics.pixels;
                      final max = scrollNotification.metrics.maxScrollExtent;

                      if (chatRoomWSModel.roomAllPage >= chatRoomWSModel.pageNum) {
                        if (scrollPosition >= max && !addData) {
                          addData = true;
                          render();
                        }
                      }
                    } else if (scrollNotification is ScrollEndNotification) {
                      if (addData) {
                        ProfileData userData = ref.watch(loginUserData);
                        chatRoomWSModel.loadRoomData(loginUserUID: userData.uid);
                        addData = false;
                      }
                    }

                    return false;
                  },
                  child: SingleChildScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    child: Column(
                      children: formattedRoomMsg.map(
                        (e) {
                          Widget component = Container();

                          if (e.runtimeType == ChatRoomMsg) {
                            if (e.userId == ref.read(loginUserData).uid) {
                              component = myMessagebuild(ref.read(loginUserData), e);
                            } else {
                              component = otherMessagebuild(roomData.userData, e);
                            }
                          } else if (e.runtimeType == String) {
                            component = chatRoomInfobuild(e);
                          }
                          return component;
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(70)),
            ],
          ),
          Positioned(
            bottom: 0,
            child: CommentBuild(
              chatRoomWSModel: chatRoomWSModel,
              dataIndex: dataIndex,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }

  Widget chatRoomInfobuild(String info) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: AppColors.greyColor54,
        ),
        child: Text(
          info,
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }

  Widget otherMessagebuild(ProfileData userData, ChatRoomMsg data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        data.needAppearImg
            ? MainBtn(
                onPress: () {
                  UserProfileAllInfoBottomSheet(needToChatRoomBtn: false, userData: userData).show(context);
                },
                child: UserIcon(
                  iconSize: 30,
                  image: userData.image,
                ),
              )
            : Container(width: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(8)),
              margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(5)),
              alignment: Alignment.centerLeft,
              child: formatMsgBuild(data.message, whoMsg: "other"),
            ),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            Text(
              DateFormatUtilities().hHMMformat(data.sentAt),
              style: TextStyle(color: AppColors.greyColor130),
            ),
          ],
        ),
      ],
    );
  }

  Widget myMessagebuild(ProfileData userData, ChatRoomMsg data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormatUtilities().hHMMformat(data.sentAt),
                style: TextStyle(color: AppColors.greyColor130),
              ),
              SizedBox(width: ScreenSize.fitPxWidth(5)),
              Container(
                margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(5)),
                alignment: Alignment.centerRight,
                child: formatMsgBuild(data.message, whoMsg: "my"),
              ),
            ],
          ),
        ),
        data.needAppearImg
            ? UserIcon(
                iconSize: 30,
                image: userData.image,
              )
            : Container(width: 30),
      ],
    );
  }

  Widget formatMsgBuild(String msg, {required String whoMsg}) {
    ///テキスト
    Widget component = msgTextContianer(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ScreenSize.width * 0.7),
        child: Text(
          msg,
          textAlign: whoMsg == "my" ? TextAlign.right : TextAlign.left,
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );

    String urlLink = splitStringAndUrls(msg).firstWhere((element) {
      return element.contains('https');
    }, orElse: () => "-1");

    /// Link
    if (urlLink != "-1") {
      component = Column(
        crossAxisAlignment: whoMsg == "my" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          msgTextContianer(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ScreenSize.width * .7),
              child: RichText(
                text: TextSpan(
                  children: splitStringAndUrls(msg).map((e) {
                    if (e.startsWith('https')) {
                      return TextSpan(
                          text: e,
                          style: TextStyle(color: AppColors.blueColor, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Uri url = Uri.parse(e);
                              launchUrl(url);
                            });
                    } else {
                      return TextSpan(text: e, style: TextStyle(color: AppColors.whiteColor));
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: ScreenSize.fitPxWidth(5)),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.greyColor57),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ScreenSize.width * 0.7, maxHeight: 160),
                  child: AnyLinkPreview(
                    link: urlLink,
                    titleStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                    backgroundColor: Colors.transparent,
                    boxShadow: const [BoxShadow(color: Colors.transparent)],
                    bodyStyle: TextStyle(color: AppColors.greyColor130, fontSize: 12),
                    borderRadius: 0,
                    bodyMaxLines: 2,
                    placeholderWidget: const Loading(),
                  ),
                ),
              ))
        ],
      );
    }

    /// 画像
    else if (msg.contains('http://\$ip:\$port')) {
      String imgUrl = RichTextFormat(htmlString: msg).mappingIPAndPort(msg);
      component = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ScreenSize.width * .7),
        child: GestureDetector(
          onTap: () async {
            print(imgUrl);
            // await imageView(RichTextFormat(htmlString: imgUrl)
            //     .mappingIPAndPort(imgUrl));
          },
          child: ClipRRect(borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(10)), child: Image.network(imgUrl)),
        ),
      );
    }

    return component;
  }

  Widget msgTextContianer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(8),
        vertical: ScreenSize.fitPxWidth(5),
      ),
      decoration: BoxDecoration(
        color: AppColors.greyColor54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  ///TopBar
  Widget userBar() {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(8)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greyColor98, width: 0.5),
        ),
      ),
      child: ChatRoomBar(backFunc: () => closePage(), userData: roomData.userData),
    );
  }
}

List formatChatMsg(List<ChatRoomMsg> messageData) {
  //例: ["2024-04-20",ChatRoomMessageModel,"2024-05-03",ChatRoomMessageModel...]
  List<dynamic> ss = [];
  //true的時候要顯示使用者圖像
  bool test = true;
  if (messageData.length == 1) {
    {
      ss.add(ChatRoomMsg(
          userId: messageData[0].userId, message: messageData[0].message, sentAt: messageData[0].sentAt, needAppearImg: true));

      DateTime now = DateTime.now().toUtc();
      String formattedTime = DateFormat("yyyy-MM-dd").format(now.toLocal());
      if (formattedTime == messageData[0].sentAt.substring(0, "yyyy-MM-dd ".length)) {
        ss.add("今日");
      } else {
        ss.add(messageData[0].sentAt.substring(0, "yyyy-MM-dd".length));
      }
    }
  } else {
    for (int i = 0; i < messageData.length; i++) {
      DateTime now = DateTime.now().toUtc();
      String formattedTime = DateFormat("yyyy-MM-dd").format(now.toLocal());
      //index : 0 - last比較
      // 防止range over 問題
      if (i < messageData.length - 1) {
        //i 與 i + 1 的 message時間不同時 ||  i 與 i + 1 的使用者不同時
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
                messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd".length) ||
            messageData[i].userId != messageData[i + 1].userId) {
          //這邊的 needAppearImg 應該都要為 false
          ss.add(ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: test ? messageData[i].sentAt : "",
              needAppearImg: true));
          // 當下一筆資料為不同使用者或是時間不同時 要顯示頭像 才讓boolean變為true
          test = true;
        } else {
          //這邊的 needAppearImg 應該都要為 true
          ss.add(ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: test ? messageData[i].sentAt : "",
              needAppearImg: false));
          //當下一筆資料為同使用者和時間相同 不要顯示頭像 才讓boolean變為false
          test = false;
        }
        //i 與 i + 1 的 message時間 不同時insert 時間
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
            messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd".length)) {
          if (formattedTime == messageData[i].sentAt.substring(0, "yyyy-MM-dd".length)) {
            ss.add("今日");
          } else {
            ss.add(messageData[i].sentAt.substring(0, "yyyy-MM-dd".length));
          }
        }
        //index : index last - last -1 比較
      } else {
        //當最後一筆資料 與 最後前一筆資料進行比對 時間不同或使用者不同時 顯示頭像
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
                messageData[i - 1].sentAt.substring(0, "yyyy-MM-dd".length) ||
            messageData[i].userId != messageData[i - 1].userId) {
          ss.add(
            ChatRoomMsg(
                userId: messageData[i].userId,
                message: messageData[i].message,
                sentAt: messageData[i].sentAt,
                needAppearImg: true),
          );
        } else {
          //當最後一筆資料 與 最後前一筆資料進行比對 時間和使用者相同時 不顯示頭像
          ss.add(ChatRoomMsg(userId: messageData[i].userId, message: messageData[i].message, sentAt: "", needAppearImg: true));
        }
        //最後一筆補上日期
        if (formattedTime == messageData[i].sentAt.substring(0, "yyyy-MM-dd".length)) {
          ss.add("今日");
        } else {
          ss.add(messageData[i].sentAt.substring(0, "yyyy-MM-dd".length));
        }
      }
    }
  }
  return ss;
}

List<String> splitStringAndUrls(String msg) {
  final urlPattern = RegExp(r'https?://\S+');
  List<String> parts = [];
  int start = 0;

  for (final match in urlPattern.allMatches(msg)) {
    if (match.start > start) {
      parts.add(msg.substring(start, match.start));
    }
    parts.add(match.group(0)!);
    start = match.end;
  }

  if (start < msg.length) {
    parts.add(msg.substring(start));
  }

  return parts;
}

final roomMessageProvider = StateProvider<ChatRoomModel>((ref) => ChatRoomModel(chatRoomMsg: []));
