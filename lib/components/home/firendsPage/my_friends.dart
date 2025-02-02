// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
// import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
// import 'package:social_mediam_match/components/utilities/main_button.dart';
// import 'package:social_mediam_match/services/friend_service.dart';
// import '../../../models/friend_model.dart';

// import '../../utilities/appBar/basic_top_bar.dart';
// import '../../utilities/dialog/await_confirm_dialog.dart';
// import '../../utilities/style/screen_size.dart';
// import '../../utilities/style/app_colors.dart';
// import '../../utilities/user_icon.dart';
// import 'my_friend_edit_bottom_sheet.dart';

// class MyFriendPage extends BaseEndDrawer {
//   @override
//   Widget build(WidgetRef ref) {
//     return Column(
//       children: [
//         BaseTopBar(
//           title: "我的好友",
//           backFunc: () {
//             closePage();
//           },
//         ),
//         Expanded(
//           child: ref.watch(frinedListProvider).isEmpty
//               ? noDataBuilder()
//               : ListView.builder(
//                   itemCount: ref.watch(frinedListProvider).length,
//                   itemBuilder: (context, index) {
//                     FriendListModel data = ref.watch(frinedListProvider)[index];
//                     return Dismissible(
//                       key: const Key(""),
//                       direction: DismissDirection.endToStart,
//                       confirmDismiss: (v) async {
//                         bool isConfirm = await awaitConfirmDialog(context, title: "提示", content: "您確定要刪除好友嗎？");
//                         if (isConfirm) {
//                           List<FriendListModel> frinedList = ref.read(frinedListProvider.notifier).state;
//                           FriendListModel deleteFriend = frinedList[index];
//                           await FriendService().deleteFriend(deleteFriend.roomId, deleteFriend.memberId);

//                           frinedList.removeAt(index);
//                           ref.read(frinedListProvider.notifier).update((state) => frinedList);
//                         }
//                         return isConfirm;
//                       },
//                       background: Container(
//                         padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(8)),
//                         color: AppColors.redColor,
//                         child: Padding(
//                           padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(20)),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Icon(
//                                 FontAwesomeIcons.trash,
//                                 color: AppColors.whiteColor,
//                                 size: ScreenSize.fontSize18,
//                               ),
//                               SizedBox(
//                                 width: ScreenSize.fitPxWidth(5),
//                               ),
//                               Text(
//                                 "刪除",
//                                 style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16), vertical: ScreenSize.fitPxWidth(8)),
//                         child: MainBtn(
//                           onPress: () {
//                             ///フレンド編集ページ
//                             MyFriendEditBtmSheet(
//                                 friendData: data.userData,
//                                 index: index,
//                                 myFriendPageRender: () {
//                                   render();
//                                 }).show(context);
//                           },
//                           child: Row(
//                             children: [
//                               UserIcon(iconSize: ScreenSize.fitPxWidth(40), image: data.userData.image),
//                               SizedBox(width: ScreenSize.fitPxWidth(10)),
//                               Expanded(
//                                 child: Text(
//                                   data.userData.name ?? "",
//                                   style: TextStyle(
//                                     fontSize: ScreenSize.fontSize14,
//                                     color: AppColors.whiteColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: 30,
//                                 alignment: Alignment.centerRight,
//                                 color: Colors.transparent,
//                                 child: Icon(
//                                   FontAwesomeIcons.ellipsis,
//                                   color: AppColors.greyColor130,
//                                   size: ScreenSize.fontSize16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//         ),
//       ],
//     );
//   }

//   Widget noDataBuilder() {
//     return SizedBox(
//       width: ScreenSize.width,
//       height: ScreenSize.height,
//       child: AspectRatio(
//         aspectRatio: 16.0 / 9.0,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
//               child: Icon(
//                 FontAwesomeIcons.userSlash,
//                 size: 50,
//                 color: AppColors.whiteColor,
//               ),
//             ),
//             SizedBox(height: ScreenSize.fitPxHeight(10)),
//             Text(
//               "目前沒有好友",
//               style: TextStyle(
//                 fontSize: ScreenSize.fontSize20,
//                 color: AppColors.greyColor130,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
