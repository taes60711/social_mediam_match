import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/services/friend_service.dart';
import '../../../models/friend_model.dart';
import '../../utilities/appBar/basic_top_bar.dart';
import '../../utilities/dialog/await_confirm_dialog.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class MyFriendPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          title: "我的好友",
          backFunc: () {
            closePage();
          },
        ),
        Expanded(
          child: ref.watch(frinedListProvider).isEmpty
              ? Container()
              : ListView.builder(
                  itemCount: ref.watch(frinedListProvider).length,
                  itemBuilder: (context, index) {
                    FriendListModel data = ref.watch(frinedListProvider)[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenSize.fitPxWidth(10),
                      ),
                      child: Dismissible(
                        key: const Key(""),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (v) async {
                          bool isConfirm = await awaitConfirmDialog(context, title: "提示", content: "您確定要刪除好友嗎？");
                          if (isConfirm) {
                            List<FriendListModel> frinedList = ref.read(frinedListProvider.notifier).state;
                            FriendListModel deleteFriend = frinedList[index];
                            await FriendService().deleteFriend(deleteFriend.roomId, deleteFriend.memberId);

                            frinedList.removeAt(index);
                            ref.read(frinedListProvider.notifier).update((state) => frinedList);
                          }
                          return isConfirm;
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
                          child: Row(
                            children: [
                              UserIcon(iconSize: ScreenSize.fitPxWidth(40), image: data.userData.image),
                              SizedBox(width: ScreenSize.fitPxWidth(10)),
                              Expanded(
                                child: Text(
                                  data.userData.name ?? "",
                                  style: TextStyle(
                                    fontSize: ScreenSize.fontSize14,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
