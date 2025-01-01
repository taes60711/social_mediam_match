import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/enum/date_format_utilities.dart';

import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/pageManager/enum/bottom_bar_path.dart';

import 'package:social_mediam_match/services/friend_service.dart';
import 'package:social_mediam_match/services/notification_service.dart';
import 'package:social_mediam_match/services/user_service.dart';

import '../../../models/friend_model.dart';
import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/friend/chat_ws_model.dart';
import '../../../provider/friend/friend_provider.dart';
import '../../../services/firebase_notification_service.dart';
import '../../home/firendsPage/chatRoomPage/chat_room.dart';
import '../../home/firendsPage/firends_page.dart';
import '../../home/skillExChangePage/skill_utilites.dart';
import '../main_button.dart';
import '../style/screen_size.dart';
import '../style/style_config.dart';
import '../toast.dart';
import '../user_icon.dart';

/// AllInfo Ver
class UserProfileAllInfoBottomSheet extends BaseBottomSheet {
  final ProfileData userData;
  bool needToChatRoomBtn;
  UserProfileAllInfoBottomSheet({required this.userData, this.needToChatRoomBtn = true});

  String notifaicationToken = "";

  @override
  Future<void> initState(WidgetRef ref) async {
    ProfileData myUserData = ref.watch(loginUserData);
    if (myUserData.uid != userData.uid) {
      bool isFriend = await FriendService().getIsFrined(userUID: myUserData.uid, ohterUserUID: userData.uid);
      notifaicationToken = await UserService().requestUserNotificationTokenByUID(userData.uid);
      ref.read(isFriendProvider.notifier).update((state) => isFriend);
      render();
    }
  }

  @override
  Widget build(WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          UserIcon(
            image: userData.image,
            iconSize: ScreenSize.fitPxHeight(80),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData.name ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize18,
                        ),
                      ),
                    ),
                    Text(
                      "${DateFormatUtilities().format(userData.lastLogin)} 上線",
                      style: TextStyle(
                        color: AppColors.greyColor130,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData.email,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                Visibility(
                  visible: userData.introduction != "",
                  child: Column(
                    children: [
                      Text(
                        userData.introduction ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize12,
                        ),
                      ),
                      SizedBox(height: ScreenSize.fitPxHeight(15)),
                    ],
                  ),
                ),

                /// チャットルーム遷移/フレンド追加ボタン
                Visibility(
                  visible: needToChatRoomBtn && ref.watch(loginUserData).uid != userData.uid,
                  child: Center(
                    child: MainBtn(
                      onPress: () {
                        if (ref.read(isFriendProvider.notifier).state == false) {
                          ChatWSModel().addFriend([ref.watch(loginUserData).uid, userData.uid]);
                          ref.read(isFriendProvider.notifier).update((state) => true);

                          String message = '"${ref.watch(loginUserData).name}"將你加為好友';

                          NotificationModel notification = NotificationModel.empty();
                          notification.userUid = ref.read(loginUserData.notifier).state.uid;
                          notification.otherUserUid = userData.uid;
                          notification.type = 2;
                          notification.title = message;
                          notification.sendNotificationuserInfo = ref.read(loginUserData.notifier).state;

                          NotificationService().createNotification(notification: notification);

                          if (notifaicationToken != "") {
                            FirebaseNotificationService().sendNotification(
                              message: message,
                              sendto: notifaicationToken,
                              notifiactionInfo: notification,
                            );
                          }

                          Toast().showBottom(msg: "添加成功");
                          render();
                        } else {
                          closePage();
                          HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.chatRoom);

                          /// メンバーIdでRoomId探す
                          int index = ref.watch(frinedListProvider).indexWhere((e) => e.memberId == userData.uid);

                          /// 探したとルームIdない場合ルーム作成者IDでRoomId探す
                          if (index == -1) {
                            index = ref.watch(frinedListProvider).indexWhere((e) => e.createdBy == userData.uid);
                          }

                          if (index != -1) {
                            FriendListModel data = ref.watch(frinedListProvider)[index];
                            ChatRoom(roomData: data, dataIndex: index).show(context);
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fitPxHeight(15),
                          vertical: ScreenSize.fitPxHeight(5),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ref.watch(isFriendProvider) ? AppColors.orangeColor : AppColors.greyColor54,
                        ),
                        child: Text(
                          ref.watch(isFriendProvider) ? "聊天室" : "新增好友",
                          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.briefcase,
                      color: AppColors.whiteColor,
                      size: ScreenSize.fontSize14,
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    Text(
                      "職業",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData.job ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),
                Row(
                  children: [
                    ///タイトル
                    Container(
                      padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                      margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 138, 138, 138),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        FontAwesomeIcons.reply,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fitPxWidth(8),
                      ),
                    ),
                    Text(
                      "能教的技能",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),

                ///得意なスキル
                SkillUtilites().skillBar(skills: userData.mainSkills!),
                SizedBox(height: ScreenSize.fitPxHeight(5)),

                Row(
                  children: [
                    ///タイトル
                    Container(
                      padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                      margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 123, 77),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        FontAwesomeIcons.share,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fitPxWidth(8),
                      ),
                    ),
                    Text(
                      "想學的技能",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),

                ///弱いスキル
                SkillUtilites().skillBar(skills: userData.wantSkills!),

                SizedBox(height: ScreenSize.fitPxHeight(5)),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(15)),
        ],
      ),
    );
  }
}

///
class UserProfileBottomSheet extends BaseBottomSheet {
  final ProfileData userData;
  UserProfileBottomSheet({required this.userData});
  @override
  Future<void> initState(WidgetRef ref) async {
    ProfileData myUserData = ref.watch(loginUserData);
    if (myUserData.uid != userData.uid) {
      bool isFriend = await FriendService().getIsFrined(userUID: myUserData.uid, ohterUserUID: userData.uid);

      ref.read(isFriendProvider.notifier).update((state) => isFriend);
      render();
    }
  }

  @override
  Widget build(WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          UserIcon(
            image: userData.image,
            iconSize: ScreenSize.fitPxHeight(80),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData.name ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize18,
                        ),
                      ),
                    ),
                    Text(
                      "${userData.lastLogin}前",
                      style: TextStyle(
                        color: AppColors.greyColor130,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData.email,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                Text(
                  userData.introduction ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(15)),

                /// チャットルーム遷移/フレンド追加ボタン
                Visibility(
                  visible: ref.watch(loginUserData).uid != userData.uid,
                  child: Center(
                    child: MainBtn(
                      onPress: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fitPxHeight(15),
                          vertical: ScreenSize.fitPxHeight(5),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ref.watch(isFriendProvider) ? AppColors.orangeColor : AppColors.greyColor54,
                        ),
                        child: Text(
                          ref.watch(isFriendProvider) ? "聊天室" : "新增好友",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "職業",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize14,
                  ),
                ),
                Text(
                  userData.job ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(15)),
        ],
      ),
    );
  }
}
