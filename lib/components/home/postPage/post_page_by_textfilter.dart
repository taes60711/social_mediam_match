// // ignore_for_file: use_build_context_synchronously

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
// import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/background_widget.dart';
// import 'package:social_mediam_match/provider/post/post_view_model.dart';
// import '../../../global.dart';
// import '../../../models/post_model.dart';
// import '../../../services/post_service.dart';
// import '../../../provider/post/post_provider.dart';
// import '../../utilities/apiListView/api_list_view.dart';
// import '../../utilities/apiListView/base_api_list_provider.dart';
// import '../../utilities/endDrawers/post_comment_end_drawer.dart';
// import '../../utilities/endDrawers/user_detail_end_drawer.dart';
// import '../../utilities/loading.dart';
// import '../../utilities/rich_text_view.dart';
// import '../../utilities/style/screen_size.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/user_icon.dart';
// import 'post_page_by_viewer.dart';

// class PostPageByTextFilter extends StatelessWidget {
//   final Function onDismissed;
//   const PostPageByTextFilter({super.key, required this.onDismissed});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController textFilterInput = context.select((PostProvider value) => value.textFilterInput);
//     Widget searchBar = Row(
//       children: [
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(left: 10, right: 4, top: 5, bottom: 10),
//             width: ScreenSize.width,
//             height: 36,
//             child: TextField(
//               cursorColor: normalBgColor2,
//               controller: textFilterInput,
//               textInputAction: TextInputAction.search,
//               onSubmitted: (value) async {
//                 await PostViewModel(context: context).searchPostByTextFilter(textFilterInput.text);
//               },
//               decoration: InputDecoration(
//                 hintText: "Search By title",
//                 hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
//                 fillColor: Colors.grey.withOpacity(0.3),
//                 focusColor: Colors.grey.withOpacity(0.3),
//                 filled: true,
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 iconColor: Colors.grey,
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.all(8),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             onDismissed();
//           },
//           child: Container(
//             margin: const EdgeInsets.only(right: 10),
//             alignment: Alignment.center,
//             width: 50,
//             height: 36,
//             child: Text(
//               "Cancel",
//               style: TextStyle(fontSize: 14, color: normalBgColor2),
//             ),
//           ),
//         )
//       ],
//     );
//     return StatefulWrapper(
//       onInit: () {
//         globalPostContext = context;
//       },
//       child: BackgroundWidget(
//         child: Column(
//           children: [
//             searchBar,
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Builder(
//                   builder: (context) {
//                     return APIListView<PostModel>(
//                       providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
//                       apiFunc: (page, size) {
//                         return PostService().getPostByTextFilter(page, size, textFilterInput.text);
//                       },
//                       loadingBuilder: () {
//                         return const PostLoading();
//                       },
//                       noInitSearchBuilder: PostViewUtilities.noinitSearchWidget(),
//                       noDataBuilder: PostViewUtilities.noPostData(),
//                       itemChild: ((data, index) {
//                         return Column(
//                           children: [
//                             /// 文章TopBar
//                             Container(
//                               width: ScreenSize.width,
//                               padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(3),
//                                 color: const Color.fromARGB(255, 236, 157, 120),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       ///アイコン
//                                       GestureDetector(
//                                         onTap: () {
//                                           openUserDetailEndDrawer(context: context, otherUserData: data[index].postUserInfo);
//                                         },
//                                         child: UserIcon(
//                                           iconSize: 35,
//                                           image: data[index].postUserInfo.image,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),

//                                       ///ユーザネーム
//                                       Text(
//                                         data[index].postUserInfo.name != ""
//                                             ? data[index].postUserInfo.name ?? ""
//                                             : data[index].postUserInfo.email,
//                                         style: TextStyle(fontSize: 12, color: normalTextColor),
//                                       ),
//                                     ],
//                                   ),

//                                   ///期日
//                                   Text(
//                                     "${data[index].postTime}${tr("skExChpage_beforDays")}",
//                                     style: TextStyle(fontSize: 12, color: normalTextColor),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             ///文章プレビュー
//                             GestureDetector(
//                               onTap: () {
//                                 openPostDetailEndDrawer(context: context, choicedPost: data[index]);
//                               },
//                               child: Container(
//                                 color: Colors.transparent,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ///Title
//                                     Text(
//                                       data[index].title,
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),

//                                     Container(
//                                         margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),

//                                     /// 文章プレビュー
//                                     RichTextView(
//                                       content: data[index].mainMessage,
//                                       isPreView: true,
//                                     ),

//                                     Container(
//                                         margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),

//                                     ///文章bottomBar
//                                     bottomBar(context: context, data: data[index]),

//                                     Container(
//                                         margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
