import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/enum/date_format_utilities.dart';

import '../../../models/friend_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../provider/account/user_provider.dart';

import '../../../services/friend_service.dart';
import '../../utilities/inputField/base_input.dart';

import '../../utilities/main_button.dart';
import 'chatRoomPage/chat_room.dart';

final frinedListProvider = StateProvider<List<FriendListModel>>((ref) => []);

final friendPageRender = StateProvider<Function>((ref) => () {});

class FriendPage extends ConsumerStatefulWidget {
  const FriendPage({super.key});

  @override
  ConsumerState<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends ConsumerState<FriendPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) async {
        ref.read(friendPageRender.notifier).update((state) => () {
              setState(() {});
            });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      type: PageType.main,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            _buildSearchBar(ref, () => setState(() {}), context),
            SizedBox(height: ScreenSize.fitPxHeight(15)),
            Text(
              BottomBarPath.chatRoom.label,
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Expanded(
              child: ref.watch(frinedListProvider).isEmpty
                  ? noDataWidget()
                  : ListView.builder(
                      itemCount: ref.watch(frinedListProvider).length,
                      itemBuilder: (context, index) {
                        FriendListModel data = ref.watch(frinedListProvider)[index];
                        return MainBtn(
                          onPress: () async {
                            ChatRoom(roomData: data, dataIndex: index).show(context);
                            await FriendService().updateUnreadCount(data.roomId, ref.watch(loginUserData).uid, 0);
                            data.unreadCount = 0;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(10)),
                            child: Row(
                              children: [
                                UserIcon(iconSize: ScreenSize.fitPxWidth(45), image: data.userData.image),
                                SizedBox(width: ScreenSize.fitPxWidth(10)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.userData.name ?? "",
                                            style: TextStyle(
                                              fontSize: ScreenSize.fontSize14,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            DateFormatUtilities().format(data.sentAt ?? ""),
                                            style: TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: ScreenSize.fitPxWidth(4)),
                                      Row(
                                        children: [
                                          /// 最新メッセージ
                                          data.lastMessage != null
                                              ? Expanded(
                                                  child: Text(
                                                    data.lastMessage!.contains("http://\$ip") ? "傳送了圖像" : "${data.lastMessage}",
                                                    style:
                                                        TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Text(
                                                    "沒有任何訊息",
                                                    style:
                                                        TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                                  ),
                                                ),

                                          ///読んでないドット
                                          Visibility(
                                            visible: data.unreadCount > 0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(6)),
                                              height: ScreenSize.fitPxWidth(10),
                                              width: ScreenSize.fitPxWidth(10),
                                              decoration: BoxDecoration(
                                                color: AppColors.orangeColor,
                                                borderRadius: BorderRadius.circular(
                                                  ScreenSize.fitPxWidth(1000),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    TextEditingController friendFilterController = TextEditingController();

    return GestureDetector(
      onTap: () async {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyColor57,
          borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(5)),
        ),
        height: ScreenSize.fitPxWidth(36),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                color: AppColors.whiteColor,
                size: ScreenSize.fontSize16,
              ),
            ),
            Expanded(
              child: BaseInputField(
                hintText: "輸入名稱",
                controller: friendFilterController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noDataWidget() {
    return SizedBox(
      width: ScreenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: Icon(
              FontAwesomeIcons.usersSlash,
              color: AppColors.whiteColor,
              size: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              "目前還沒有任何訊息",
              style: TextStyle(
                color: AppColors.greyColor98,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
