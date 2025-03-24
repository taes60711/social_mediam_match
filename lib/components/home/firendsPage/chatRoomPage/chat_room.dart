import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screen_state/screen_state.dart';
import 'package:social_mediam_match/components/home/firendsPage/chatRoomPage/chat_room_manager_btm_sheet.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/image_view_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/chat_room_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/enum/date_format_utilities.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../../models/friend_model.dart';
import '../../../../models/rich_text_format.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../provider/friend/chat_room_ws_model.dart';
import '../../../../services/friend_service.dart';
import '../../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';
import 'package:any_link_preview/any_link_preview.dart';

import '../firends_page.dart';
import 'comment_build.dart';

class ChatRoom extends BaseEndDrawer with WidgetsBindingObserver {
  FriendListModel roomData;
  int dataIndex;

  ChatRoom({required this.roomData, required this.dataIndex});

  bool isInit = false;
  ChatRoomWSModel chatRoomWSModel = ChatRoomWSModel();

  List formattedRoomMsg = [];
  final _scrollController = ScrollController();
  bool addData = false;

  Screen screen = Screen();

  StreamSubscription<ScreenStateEvent>? _subscription;
  @override
  Future<void> initState(WidgetRef ref) async {
    ProfileData myUserData = ref.watch(loginUserData);
    chatRoomWSModel.init(ref, () => render(), () => closePage(), userId: myUserData.uid, roomData: roomData);
    HomeGlobalViewModel().bottomBarHideStateChage(false);

    WidgetsBinding.instance.addObserver(this);
    _subscription = screen.screenStateStream.listen(didChangeScreenState);
  }

  @override
  Future<void> dispose(WidgetRef ref) async {
    WidgetsBinding.instance.removeObserver(this);
    _subscription!.cancel();

    /// 未読数リセット
    unreadReset();
    chatRoomWSModel.closeRoom();

    print("chatRoom dispose");
  }

  void didChangeScreenState(ScreenStateEvent event) {
    if (event == ScreenStateEvent.SCREEN_OFF) {
      chatRoomWSModel.screenOFF();
      print("Component cahtRoom : SCREEN_OFF");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /// App最小化
    if (state == AppLifecycleState.paused) {
      chatRoomWSModel.appToBackground();
      print("Component cahtRoom : app paused");
    }

    /// App最小化 > 戻る > WSもう一度繋がる > 画面のメッセージを更新する
    if (state == AppLifecycleState.resumed) {
      ProfileData myUserData = ref.watch(loginUserData);

      if (chatRoomWSModel.isOffScreen) {
        chatRoomWSModel.offScreenRetrun(userId: myUserData.uid, roomData: roomData, scrollController: _scrollController);
        Future.delayed(const Duration(seconds: 1)).then((value) {
          chatRoomWSModel.isOffScreen = false;
          render();
        });
      } else if (chatRoomWSModel.inBackground) {
        chatRoomWSModel.appRetrun(userId: myUserData.uid, roomData: roomData);
      }

      print("Component cahtRoom : app resumed");
    }

    /// app クローズ
    if (state == AppLifecycleState.detached) {
      /// 未読数リセット
      unreadReset();
      print("Component cahtRoom : app close");
    }
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
              Expanded(
                child: chatRoomWSModel.isOffScreen
                    ? const Center(
                        child: Loading(),
                      )
                    : Column(
                        children: [
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
                                }

                                if (scrollNotification is ScrollEndNotification) {
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
              ),
            ],
          ),
          chatRoomWSModel.isOffScreen
              ? Container()
              : Positioned(
                  bottom: 0,
                  child: CommentBuild(
                    roomData: roomData,
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
        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(3), horizontal: ScreenSize.fitPxWidth(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(5)),
          color: AppColors.greyColor54.withOpacity(0.5),
        ),
        child: Text(
          info,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: ScreenSize.fontSize14,
          ),
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
              style: TextStyle(
                color: AppColors.greyColor130,
                fontSize: ScreenSize.fontSize10,
              ),
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
                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize10),
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
        child: GestureDetector(
          onDoubleTap: () {
            Clipboard.setData(ClipboardData(text: msg));
            Toast().showBottom(msg: "已複製文字");
          },
          child: SelectableText.rich(
            textAlign: TextAlign.left,
            TextSpan(
              text: msg,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize14,
              ),
            ),
          ),
        ),
      ),
    );

    String urlLink = splitStringAndUrls(msg).firstWhere((element) {
      return element.contains('https');
    }, orElse: () => "-1");

    bool isDataBaseImg = msg.contains('${APIHttpController.prefixUrl}://${APIHttpController.databaseDomainStr}') ? true : false;

    /// 画像
    if (isDataBaseImg) {
      String imgUrl = RichTextFormat(htmlString: msg).mappingIPAndPort(msg);
      component = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ScreenSize.width * .7),
        child: GestureDetector(
          onTap: () async {
            print(imgUrl);

            ImageViewPage(imgUrl: imgUrl).show(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(10)),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              placeholder: (context, url) {
                return Container(
                  width: ScreenSize.width * .7,
                  height: ScreenSize.fitPxWidth(200),
                  color: AppColors.black37,
                  child: const Loading(),
                );
              },
            ),
          ),
        ),
      );

      /// Link
    } else if (urlLink != "-1") {
      component = Column(
        crossAxisAlignment: whoMsg == "my" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          msgTextContianer(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ScreenSize.width * .7),
              child: GestureDetector(
                onDoubleTap: () {
                  Clipboard.setData(ClipboardData(text: msg));
                  Toast().showBottom(msg: "已複製文字");
                },
                child: SelectableText.rich(
                  TextSpan(
                    children: splitStringAndUrls(msg).map((e) {
                      if (e.startsWith('https')) {
                        return TextSpan(
                            text: e,
                            style: TextStyle(
                              color: AppColors.blueColor,
                              decoration: TextDecoration.underline,
                              fontSize: ScreenSize.fontSize14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await HomeGlobalViewModel().launcherURL(
                                  strUrl: e,
                                  needPopAllPage: false,
                                );
                              });
                      } else {
                        return TextSpan(
                          text: e,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize14,
                          ),
                        );
                      }
                    }).toList(),
                  ),
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
                  backgroundColor: AppColors.transparent,
                  boxShadow: [BoxShadow(color: AppColors.transparent)],
                  bodyStyle: TextStyle(color: AppColors.greyColor130, fontSize: 12),
                  borderRadius: 0,
                  bodyMaxLines: 2,
                  placeholderWidget: const Loading(),
                ),
              ),
            ),
          )
        ],
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
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(8)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.greyColor98, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ChatRoomBar(
                backFunc: () => closePage(),
                userData: roomData.userData,
                rightFunc: () {
                  ChatRoomManagerBtmSheet(roomId: roomData.roomId, friendData: roomData.userData).show(context);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 未読数リセット
  void unreadReset() {
    /// 未読数リセット
    FriendService().updateUnreadCount(roomData.roomId, ref.watch(loginUserData).uid, 0);
    ref.read(frinedListProvider.notifier).state[dataIndex].unreadCount = 0;
    List<FriendListModel> friendList = ref.read(frinedListProvider.notifier).state.map((e) => e.copyWith()).toList();
    friendList[dataIndex].unreadCount = 0;
    ref.read(frinedListProvider.notifier).update((state) => friendList);

    ref.read(friendPageRender.notifier).state();
  }
}

List formatChatMsg(List<ChatRoomMsg> messageData) {
  //例: ["2024-04-20",ChatRoomMessageModel,"2024-05-03",ChatRoomMessageModel...]
  List<dynamic> formattedMsg = [];
  //true的時候要顯示使用者圖像
  bool nextDataNeedAppearImg = true;
  if (messageData.length == 1) {
    {
      formattedMsg.add(
        ChatRoomMsg(
          userId: messageData[0].userId,
          message: messageData[0].message,
          sentAt: messageData[0].sentAt,
          needAppearImg: true,
        ),
      );

      formattedMsg.add(getMsgInfoDate(messageData[0].sentAt));
    }
  } else {
    for (int i = 0; i < messageData.length; i++) {
      //index : 0 - last比較
      // 防止range over 問題
      if (i < messageData.length - 1) {
        //i 與 i + 1 的 message時間不同時 ||  i 與 i + 1 的使用者不同時
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
                messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd".length) ||
            messageData[i].userId != messageData[i + 1].userId) {
          //這邊的 needAppearImg 應該都要為 false
          formattedMsg.add(
            ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: nextDataNeedAppearImg ? messageData[i].sentAt : "",
              needAppearImg: true,
            ),
          );
          // 當下一筆資料為不同使用者或是時間不同時 要顯示頭像 才讓boolean變為true
          nextDataNeedAppearImg = true;
        } else {
          //這邊的 needAppearImg 應該都要為 true
          formattedMsg.add(
            ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: nextDataNeedAppearImg ? messageData[i].sentAt : "",
              needAppearImg: false,
            ),
          );
          //當下一筆資料為同使用者和時間相同 不要顯示頭像 才讓boolean變為false
          nextDataNeedAppearImg = false;
        }
        //i 與 i + 1 的 message時間 不同時insert 時間
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
            messageData[i + 1].sentAt.substring(0, "yyyy-MM-dd".length)) {
          formattedMsg.add(getMsgInfoDate(messageData[i].sentAt));
        }
        //index : index last - last -1 比較
      } else {
        //當最後一筆資料 與 最後前一筆資料進行比對 時間不同或使用者不同時 顯示頭像
        if (messageData[i].sentAt.substring(0, "yyyy-MM-dd".length) !=
                messageData[i - 1].sentAt.substring(0, "yyyy-MM-dd".length) ||
            messageData[i].userId != messageData[i - 1].userId) {
          formattedMsg.add(
            ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: messageData[i].sentAt,
              needAppearImg: true,
            ),
          );
        } else {
          //當最後一筆資料 與 最後前一筆資料進行比對 時間和使用者相同時 不顯示頭像
          formattedMsg.add(
            ChatRoomMsg(
              userId: messageData[i].userId,
              message: messageData[i].message,
              sentAt: "",
              needAppearImg: true,
            ),
          );
        }

        //最後一筆補上日期
        formattedMsg.add(getMsgInfoDate(messageData[i].sentAt));
      }
    }
  }
  return formattedMsg;
}

///　取得format過的日期資訊（聊天室中間的）
String getMsgInfoDate(String msgTime) {
  String formattedNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String formattedYesterday = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 1)));
  String formattedSendMsgTime = DateFormatUtilities().utcTimeToLocalFormat(msgTime);

  if (formattedSendMsgTime.contains(formattedNow)) {
    return "今日";
  } else if (formattedSendMsgTime.contains(formattedYesterday)) {
    return "昨日";
  } else {
    return DateFormatUtilities().utcTimeToLocalMMddFormat(msgTime);
  }
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
