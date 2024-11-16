// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../components/home/postPage/post_detail_page.dart';
import '../../components/home/postPage/post_type_board/post_page_by_type.dart';
import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../components/utilities/dialog/confirm_dialog.dart';
import '../../global.dart';
import '../../models/rich_text_format.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';
import 'post_provider.dart';

class PostViewModel {
  final WidgetRef ref;
  final Function render;
  final BuildContext context;
  PostViewModel({required this.ref, required this.context, required this.render});

  ///文章作る
  Future<void> postCreate({required String postTitle, required String postContent, PostBoard? postBoard}) async {
    ProfileData userData = ref.watch(loginUserData);

    int postType = ref.read(postCreateChoiceBoard).type;

    String fomattedContent = await RichTextFormat(htmlString: postContent).sendPostImgFormat();
    print("Title $postTitle Board: $postType   Message : $fomattedContent  Type: ${ref.watch(postCreateChoiceBoard).id}");
    int postIndex = await PostService().createPost(userData.uid, postTitle, fomattedContent, ref.watch(postCreateChoiceBoard).id);
    print("Create PostIndex ${postIndex}");
    PostModel post = PostModel(
      id: postIndex,
      createdBy: userData.uid,
      title: postTitle,
      type: postType,
      mainMessage: fomattedContent,
      commentCount: 0,
      postTime: PostModel.dateFormatted(DateTime.now().toUtc().toString()),
      postUserInfo: userData,
    );

    Navigator.of(globalContext).pop();
    if (postBoard == null) {
      ref.read(choicedPostBoardProvider.notifier).update((state) => ref.read(postCreateChoiceBoard));
      PostPageByType().show(context);
    } else {
      ref.read(typelistControllerProvider).scrollController.jumpTo(0);
      ref.read(typelistControllerProvider.notifier).addDataTofirst(post);
      render();
    }
  }

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

    choiceData.commentCount++;

    /// 詳細ページのコメント”数”更新する
    ref.read(choicedPostProvider.notifier).state = PostModel().copyWith(data: choiceData);
    if (postListController != null) {
      /// Listページのコメント”数”更新する
      ref.read(postListController.notifier).editData(dataIndex, choiceData);
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
