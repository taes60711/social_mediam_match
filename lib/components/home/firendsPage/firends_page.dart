import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/services/user_service.dart';
import '../../../global/chat_ws_model.dart';
import '../../../models/friend_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/friend_service.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';

import '../../utilities/inputField/base_input.dart';

import '../../utilities/main_button.dart';
import 'search_user_page.dart';

final frinedListProvider = StateProvider<List<FriendListModel>>((ref) => []);

final suggestUserProvider = StateProvider<List<ProfileData>>((ref) => []);

class FriendPage extends ConsumerStatefulWidget {
  const FriendPage({super.key});

  @override
  ConsumerState<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends ConsumerState<FriendPage> {
  @override
  void initState() {
    ChatWSModel().listen()?.listen((event) {
      print("FriendPage received: $event");
      init(event);
    });
    Future.delayed(Duration.zero).then(
      (value) async {
        if (ref.read(suggestUserProvider).isEmpty) {
          List<ProfileData> suggestUserDataList = await UserService().getADUserData(8, userUid: ref.watch(loginUserData).uid);
          ref.read(suggestUserProvider.notifier).update((state) => suggestUserDataList);
          setState(() {});
        }
      },
    );
    super.initState();
  }

  Future<void> init(event) async {
    if (event != "is already Friend") {
      String searchUrl = jsonDecode((event))['apiUrl'];
      List<FriendListModel> tempfriendList = await FriendService().getFriendList(searchUrl);
      String initDate = "1997-01-01T00:00:00.000+00:00";
      tempfriendList.sort((a, b) => DateTime.parse(a.sentAt ?? initDate).compareTo(DateTime.parse(b.sentAt ?? initDate)));
      tempfriendList = tempfriendList.map((e) {
        return friendListFormatDate(e);
      }).toList();

      ref.read(frinedListProvider.notifier).update((state) => tempfriendList);
    }
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
              "推薦",
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize20, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                SizedBox(width: ScreenSize.fitPxWidth(10)),
                MainBtn(
                  onPress: () {
                    SearchUserPage().show(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.plus,
                          color: AppColors.greyColor98,
                          size: ScreenSize.fontSize14,
                        ),
                        SizedBox(height: ScreenSize.fitPxHeight(5)),
                        Text(
                          "新增好友",
                          style: TextStyle(
                            fontSize: ScreenSize.fontSize12,
                            color: AppColors.greyColor130,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ScreenSize.fitPxWidth(15)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ref.read(suggestUserProvider).map((e) {
                        return Padding(
                          padding: EdgeInsets.only(right: ScreenSize.fontSize12),
                          child: GestureDetector(
                            onTap: () {
                              UserProfileAllInfoBottomSheet(userData: e).show(context);
                            },
                            child: UserIcon(
                              iconSize: ScreenSize.fitPxWidth(40),
                              image: e.image,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenSize.fitPxHeight(15)),
            Text(
              "訊息",
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
                        return Padding(
                          padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(10)),
                          child: Row(
                            children: [
                              UserIcon(iconSize: ScreenSize.fitPxWidth(40), image: data.userData.image),
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
                                          data.sentAt ?? "",
                                          style: TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                        ),
                                      ],
                                    ),
                                    data.lastMessage != null
                                        ? Text(
                                            data.lastMessage!.contains("http://\$ip") ? "傳送了圖像" : "${data.lastMessage}",
                                            style: TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            "沒有任何訊息",
                                            style: TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.greyColor98),
                                          ),
                                  ],
                                ),
                              )
                            ],
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
    return GestureDetector(
      onTap: () async {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyColor57,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 36,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search, color: AppColors.whiteColor),
            ),
            Expanded(
              child: BaseInputField(
                hintText: "搜尋",
                controller: TextEditingController(),
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
            padding: const EdgeInsets.only(right: 25, bottom: 10),
            child: Icon(
              FontAwesomeIcons.usersSlash,
              color: AppColors.greyColor98,
              size: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 15),
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
