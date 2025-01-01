import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../../models/friend_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/friend_service.dart';
import '../../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../../utilities/dialog/await_confirm_dialog.dart';
import '../firends_page.dart';

/// チャットルーム内の編集ページ
class ChatRoomManagerBtmSheet extends BaseBottomSheet {
  ProfileData friendData;
  ChatRoomManagerBtmSheet({required this.friendData});

  @override
  double buildHeight() {
    return 0.15;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        managerPageMainBtn(
            iconData: FontAwesomeIcons.trash,
            text: "刪除好友",
            onPress: () async {
              bool isConfirm = await awaitConfirmDialog(context, title: "提示", content: "您確定要刪除好友嗎？");
              if (isConfirm) {
                List<FriendListModel> frinedList = ref.read(frinedListProvider.notifier).state;

                int deleteFriendDataIndex = frinedList.indexWhere((e) {
                  String memberId = e.createdBy;
                  if (ref.read(loginUserData.notifier).state.uid == e.createdBy) {
                    memberId = e.memberId;
                  }

                  return memberId == friendData.uid;
                });

                FriendListModel deleteFriend = frinedList[deleteFriendDataIndex];
                await FriendService().deleteFriend(deleteFriend.roomId, deleteFriend.memberId);

                frinedList.removeAt(deleteFriendDataIndex);
                ref.read(frinedListProvider.notifier).update((state) => frinedList);
                ref.read(friendPageRender.notifier).state();
                HomeGlobalViewModel().popUntiltFirst();
              }
            }),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
      ],
    );
  }

  Widget managerPageMainBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
          vertical: ScreenSize.fitPxWidth(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor54,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize14,
            ),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
