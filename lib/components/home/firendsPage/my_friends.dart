// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';
// import 'package:social_mediam_match/components/utilities/endDrawers/user_detail_end_drawer.dart';
// import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
// import 'package:social_mediam_match/provider/account/user_provider.dart';

// import '../../../models/friend_model.dart';
// import '../../../models/user_model.dart';
// import '../../../pagemanager/setting/route_controller.dart';
// import '../../../provider/friend_provider.dart';
// import '../../utilities/custom_button.dart';
// import '../../utilities/style/screen_size.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/user_icon.dart';

// class MyFriends extends StatelessWidget {
//   const MyFriends({super.key});

//   @override
//   Widget build(BuildContext context) {
//     FriendProvider friendFuture = context.read<FriendProvider>();
//     List<FriendListModel> friendList = context.watch<FriendProvider>().friendList;

//     Future<void> deleteFriendCheck({required List<String> members, required int roomId}) {
//       return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: EdgeInsets.zero,
//             content: SizedBox(
//               width: 150,
//               height: 150,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   BaseTopBar(
//                     leftWidget: Container(),
//                     centerWidget: Text(tr("friend_delete_check")),
//                   ),
//                   const Expanded(child: SizedBox(height: 10)),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextBtn(
//                             title: tr("cancel"),
//                             titleColor: normalTextColor,
//                             btnColor: hintTextColor,
//                             onPress: () {
//                               RouteOptions.pop();
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: TextBtn(
//                             title: tr("confirm"),
//                             titleColor: normalTextColor,
//                             btnColor: normalBgColor,
//                             onPress: () async {
//                               friendFuture.deleteFriend(members, roomId);
//                               RouteOptions.pop();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }

//     return Stack(
//       children: [
//         Scaffold(
//           body: SafeArea(
//             child: Column(
//               children: [
//                 BaseTopBar(title: tr("myfriend_title")),
//                 Expanded(
//                   child: ListView.builder(
//                     physics: const NoBouncingScrollPhysics(),
//                     itemCount: friendList.length,
//                     itemBuilder: (_, index) {
//                       FriendListModel listInfo = friendList[index];
//                       ProfileData otherUserData = listInfo.userData;
//                       return Container(
//                         width: ScreenSize.width,
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(width: 0.1, color: normalBgColor2),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
//                           child: GestureDetector(
//                             onTap: () {
//                               openUserDetailEndDrawer(context: context, otherUserData: otherUserData);
//                             },
//                             child: Container(
//                               color: Colors.transparent,
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: UserIcon(
//                                       iconSize: 50,
//                                       image: otherUserData.image,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Text(otherUserData.name ?? otherUserData.email),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       deleteFriendCheck(
//                                         roomId: listInfo.roomId,
//                                         members: [context.read<UserProvider>().userData.uid],
//                                       );
//                                     },
//                                     child: Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: normalBgColor2,
//                                       ),
//                                       child: const Icon(
//                                         FontAwesomeIcons.close,
//                                         color: Colors.white,
//                                         size: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         userDetailEndDrawer(),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
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
                    );
                  }),
        ),
      ],
    );
  }
}
