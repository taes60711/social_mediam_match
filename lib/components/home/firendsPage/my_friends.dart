import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/services/friend_service.dart';
import '../../../models/friend_model.dart';
import '../../utilities/appBar/basic_top_bar.dart';
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
                          bool isConfirm = await _showCustomDialog(context);
                          if (isConfirm) {
                            List<FriendListModel> frinedList = ref.read(frinedListProvider.notifier).state;
                            FriendListModel deleteFriend = frinedList[index];
                            await FriendService().deleteFriend(deleteFriend.roomId, deleteFriend.memberId);

                            frinedList.removeAt(index);
                            ref.read(frinedListProvider.notifier).update((state) => frinedList);
                          }
                          return isConfirm;
                        },
                        onDismissed: (direction) {
                          print(direction);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
                          child: Row(
                            children: [
                              UserIcon(iconSize: ScreenSize.fitPxWidth(40), image: data.userData.image),
                              SizedBox(width: ScreenSize.fitPxWidth(10)),
                              Text(
                                data.userData.name ?? "",
                                style: TextStyle(
                                  fontSize: ScreenSize.fontSize14,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

// delete friend check
Future<bool> _showCustomDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fitPxWidth(25),
                vertical: ScreenSize.fitPxHeight(15),
              ),
              decoration: BoxDecoration(
                color: AppColors.greyColor54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "提示",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize22),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "您確定要刪除好友嗎？",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: MainBtn(
                          backgroundColor: AppColors.black37,
                          padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                          onPress: () {
                            Navigator.pop(context, false);
                          },
                          title: "取消",
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(15)),
                      Expanded(
                        child: MainBtn(
                          padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                          backgroundColor: AppColors.orangeColor,
                          onPress: () {
                            Navigator.pop(context, true);
                          },
                          title: "確認",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}
