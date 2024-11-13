// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/home/postPage/post_comment_page.dart';
// import 'package:social_mediam_match/models/user_model.dart';
// import 'package:social_mediam_match/provider/post/post_provider.dart';
// import '../../components/utilities/apiListView/base_api_list_provider.dart';
// import '../../components/utilities/basic_top_bar.dart';
// import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
// import '../../components/utilities/style/style_config.dart';
// import '../../global.dart';
// import '../../models/post_model.dart';
// import '../../models/rich_text_format.dart';
// import '../../pageManager/setting/route_controller.dart';
// import '../../services/post_service.dart';
// import '../account/user_provider.dart';
// import 'post_comment_provider.dart';

// class PostViewModel {
//   BuildContext context;
//   PostViewModel({required this.context});

//   Future<void> createPost({required String title, required String msg, required int type}) async {
//     ProfileData userData = context.read<UserProvider>().userData;
//     String fomattedContent = await RichTextFormat(htmlString: msg).sendPostImgFormat();

//     await PostService().createPost(userData.uid, title, fomattedContent, type);

//     PostModel createdData = PostModel(
//       id: 0,
//       createdBy: userData.uid,
//       title: title,
//       mainMessage: fomattedContent,
//       postTime: PostModel.dateFormatted(DateTime.now().toUtc().toString()),
//       type: type,
//       postUserInfo: userData,
//     );

//     context.read<BaseAPIListProvider<PostModel>>().createData(createdData: createdData);
//   }

//   void showOptionBottomSheet({required PostModel choicedPost}) {
//     showModalBottomSheet(
//         context: globalContext,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (builder) {
//           return DraggableScrollableSheet(
//               expand: false,
//               minChildSize: 0.25,
//               initialChildSize: 0.3,
//               maxChildSize: 0.3,
//               builder: (context, scrollController) {
//                 return Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(10),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         BaseTopBar(
//                           leftWidget: Container(),
//                           centerWidget: Icon(
//                             Icons.remove,
//                             size: 35,
//                             color: normalBgColor2,
//                           ),
//                           rightWidget: Container(
//                             color: Colors.transparent,
//                             padding: const EdgeInsets.all(5),
//                             child: GestureDetector(
//                               onTap: () => RouteOptions.pop(),
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 25,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               _bottomSheetBtn(
//                                   icon: Icons.edit,
//                                   btnText: "分享",
//                                   bntFunc: () {
//                                     RouteOptions.pop();
//                                   }),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ));
//               });
//         });
//   }

//   void showPostCommentPageSheet({required PostModel choicedPost}) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (builder) {
//           return MultiProvider(
//             providers: [
//               ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostCommentTextEditorModel>()),
//               ChangeNotifierProvider(create: (_) => PostCommentProvider()),
//             ],
//             child: DraggableScrollableSheet(
//               expand: false,
//               minChildSize: 0.55,
//               initialChildSize: 0.6,
//               maxChildSize: 0.6,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                   ),
//                   child: PostCommentPage(choicedPost: choicedPost),
//                 );
//               },
//             ),
//           );
//         });
//   }

// Widget _bottomSheetBtn({required IconData icon, required String btnText, required bntFunc}) {
//   return GestureDetector(
//     onTap: () {
//       bntFunc();
//     },
//     child: Container(
//       margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
//       height: 45,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: normalBgColor2,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: normalTextColor,
//             size: 25,
//           ),
//           const SizedBox(width: 10),
//           SizedBox(
//             width: 70,
//             child: Text(
//               btnText,
//               style: TextStyle(color: normalTextColor),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../components/home/postPage/post_detail_page.dart';
import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../components/utilities/dialog/confirm_dialog.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';
import 'post_provider.dart';

class PostViewModel {
  final WidgetRef ref;
  final Function render;
  final BuildContext context;
  PostViewModel({required this.ref, required this.context, required this.render});

  ///文章詳細ページ開く
  Future<void> postDetailPageInit(
    StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>> postListController,
    PostModel data,
    int dataIndex,
  ) async {
    ProfileData userData = ref.watch(loginUserData);
    if (data.createdBy != userData.uid) {
      /// ビュー”数”更新する
      await PostService().updatePostViewCount(data.id);
      if (data.type != -1) {
        data.viewed++;

        /// Listページのビュー”数”更新する
        ref.read(postListController.notifier).editData(dataIndex, data);
      }
    }

    ref.read(choicedPostProvider.notifier).update((state) => data);

    ///”いいねしたこと”どうか取得する
    bool isGooded = await PostService().checkIsPostGood(postId: data.id, userUID: userData.uid);
    ref.read(choicedPostIsGoodProvider.notifier).update((state) => isGooded);

    /// 詳細ページ開く
    PostDetailPage(dataIndex: dataIndex, postListController: postListController).show(context);
  }

  ///いいねする
  Future<void> lookingPostGoodOnChange(
    bool isGooded, {
    required int dataIndex,
    required StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController,
  }) async {
    PostModel choiceData = ref.read(choicedPostProvider);
    ProfileData userData = ref.watch(loginUserData);
    if (isGooded) {
      ///いいねたす
      choiceData.good--;
      await PostService().updatePostGood(choiceData.id);
    } else {
      ///いいねひく
      choiceData.good++;
      await PostService().updatePostGood(choiceData.id, userUID: userData.uid);
    }
    ref.read(choicedPostIsGoodProvider.notifier).update((state) => !isGooded);

    ///文章リストのいいね更新する
    if (postListController != null) {
      ref.read(postListController.notifier).editData(dataIndex, choiceData);
    }

    render();
  }

  ///コメント作成
  Future<void> postCommentCreate({
    required String message,
    required int dataIndex,
    required StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController,
  }) async {
    PostModel choiceData = ref.read(choicedPostProvider);
    ProfileData userData = ref.watch(loginUserData);
    int uid = await PostService().createPostComment(postUID: choiceData.id, userUID: userData.uid, message: message);
    DateTime dateUtc = DateTime.now().toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());
    PostCommentTextEditorModel sdsat = PostCommentTextEditorModel(
      uid: uid,
      postId: ref.read(choicedPostProvider.notifier).state.id,
      userUid: userData.uid,
      message: message,
      postTime: formattedTime,
      commentUserInfo: userData,
      isEditor: false,
      textEditingController: TextEditingController(text: message),
    );

    ///コメントListにコメント追加する
    ref.read(postCommentListControllerProvider.notifier).addDataTofirst(sdsat);

    PostModel c = choiceData;
    c.commentCount++;

    /// 詳細ページのコメント”数”更新する
    ref.read(choicedPostProvider.notifier).state = PostModel().copyWith(data: c);
    if (postListController != null) {
      /// Listページのコメント”数”更新する
      ref.read(postListController.notifier).editData(dataIndex, c);
    }

    render();
  }

  ///コメント編集
  Future<void> postCommentEdit({required PostCommentTextEditorModel data}) async {
    String newMessage = data.textEditingController.text;
    data.isEditor = !data.isEditor;
    if (data.message != newMessage) {
      await PostService().updatePostComment(id: data.uid, mainMessage: newMessage);
      data.message = newMessage;
    }
    render();
  }

  ////コメント削除確認
  Future<void> postCommentDeleteCheck({
    required PostCommentTextEditorModel data,
    required int dataIndex,
    StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController,
  }) async {
    ///削除確認
    ConfirmDilaog(
      title: "提示",
      content: "確定要刪除該回覆？",
      conirmFunc: () async {
        ///削除実行する
        await PostService().deletePostComment(id: data.uid);

        PostModel choiceData = ref.read(choicedPostProvider);

        PostModel c = choiceData;
        c.commentCount--;

        /// 詳細ページのコメント”数”更新する
        ref.read(choicedPostProvider.notifier).state = PostModel().copyWith(data: c);

        ///コメントListのコメント削除
        ref.read(postCommentListControllerProvider.notifier).removeData(dataIndex);
        if (postListController != null) {
          /// Listページのコメント”数”更新する
          ref.read(postListController.notifier).editData(dataIndex, c);
        }
        render();
      },
    ).show(context);
  }
}
