import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/home/postPage/post_main_page.dart';

import '../../../models/post_model.dart';

import '../../utilities/rich_text_view.dart';

// class PostDetailPage extends StatelessWidget {
//   const PostDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     PostModel viewChoicedPost = context.watch<PostCommentProvider>().viewChoicedPost;
//     print("postDetailPage");
//     return Container(
//       color: Colors.white,
//       height: ScreenSize.height,
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: ScreenSize.width,
//                     padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(3),
//                       color: const Color.fromARGB(255, 236, 157, 120),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 openUserDetailEndDrawer(context: context, otherUserData: viewChoicedPost.postUserInfo);
//                               },
//                               child: UserIcon(
//                                 iconSize: 35,
//                                 image: viewChoicedPost.postUserInfo.image,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               viewChoicedPost.postUserInfo.name != ""
//                                   ? viewChoicedPost.postUserInfo.name ?? ""
//                                   : viewChoicedPost.postUserInfo.email,
//                               style: TextStyle(fontSize: 12, color: normalTextColor),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "${viewChoicedPost.postTime}${tr("skExChpage_beforDays")}",
//                           style: TextStyle(fontSize: 12, color: normalTextColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   RichTextView(content: viewChoicedPost.mainMessage),
//                   const SizedBox(height: 10),
//                   Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 0.2, color: normalBgColor2),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Row(
//                       children: [
//                         Builder(builder: (context) {
//                           bool isGood = context.select((PostProvider value) => value.isGood);
//                           return GestureDetector(
//                             onTap: () {
//                               PostViewModel(context: context).updatePostGood(isGood: isGood, viewChoicedPost: viewChoicedPost);
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               child: Center(
//                                 child: Container(
//                                   padding: const EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(width: .7, color: normalBgColor),
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: Icon(
//                                     isGood ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
//                                     color: normalBgColor,
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                         Builder(builder: (context) {
//                           int choicedPostGoodCount = context.select((PostCommentProvider value) => value.viewChoicedPost.good);
//                           return Text(
//                             "$choicedPostGoodCount",
//                             style: TextStyle(
//                               color: normalBgColor,
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       PostViewModel(context: context).showPostCommentPageSheet(choicedPost: viewChoicedPost);
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "回覆 : ${viewChoicedPost.commentCount} 件",
//                           style: TextStyle(color: AppColors.normalblackColor),
//                         ),
//                         Row(
//                           children: [
//                             UserIcon(
//                               iconSize: 25,
//                               image: context.watch<UserProvider>().userData.image,
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Container(
//                                 height: 30,
//                                 alignment: Alignment.centerLeft,
//                                 decoration: BoxDecoration(color: AppColors.bgColor),
//                                 child: const Padding(
//                                   padding: EdgeInsets.only(left: 5),
//                                   child: Text(
//                                     "留言",
//                                     style: TextStyle(color: Colors.grey, fontSize: 14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               margin: const EdgeInsets.only(left: 5),
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               decoration:
//                                   BoxDecoration(borderRadius: BorderRadius.circular(5), color: normalBgColor2.withOpacity(0.5)),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.send,
//                                   size: 16,
//                                   color: normalTextColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailState();
}

PostModel choicedPost = PostModel();

class _PostDetailState extends ConsumerState<PostDetailPage> {
  @override
  void initState() {
    choicedPost = ref.read(choicedPostProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichTextView(content: choicedPost.mainMessage),
    );
  }
}
