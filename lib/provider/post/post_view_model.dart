// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/models/rich_text_format.dart';
import 'package:social_mediam_match/services/notification_service.dart';
import 'package:social_mediam_match/services/user_service.dart';
import 'package:uuid/uuid.dart';
import '../../components/home/postPage/post_detail_page.dart';
import '../../components/home/postPage/post_type_board/post_page_by_type.dart';
import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../components/utilities/dialog/confirm_dialog.dart';
import '../../global.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../services/firebase_notification_service.dart';
import '../../services/image_service.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';
import 'post_provider.dart';

class PostViewModel {
  final WidgetRef ref;
  final Function render;
  final BuildContext context;
  PostViewModel({required this.ref, required this.context, required this.render});

  String notificationToken = "";

  Future<void> init() async {
    PostModel choiceData = ref.watch(choicedPostProvider);
    notificationToken = await UserService().requestUserNotificationTokenByUID(choiceData.postUserInfo.uid);
  }

  ///文章作る前チェック
  bool postCreateBeforCheck({required String postContent}) {
    bool isOk = true;

    postContent = postContent..replaceAll(" ", "");
    if (postContent == "") {
      String content = "";
      content = "\"內文\"不得為空";
      isOk = false;
      ConfirmDilaog(title: '警告', content: content).show(context);
    }
    return isOk;
  }

  ///文章作る
  Future<void> postCreate({required String mainMessage, required List<String> fileMessage, PostBoard? postBoard}) async {
    ProfileData userData = ref.watch(loginUserData);

    PostBoard postTypeBoard = ref.read(postCreateChoiceBoard);

    if (postBoard != null) {
      postTypeBoard = postBoard;
    }

    print(" Board: ${postTypeBoard.type} Message : $mainMessage File : $fileMessage  Type: ${postTypeBoard.id}");

    String fileMessageStr = "[]";

    List<String> uploadedfileList = [];
    if (fileMessage.isNotEmpty) {
      await Future.forEach(fileMessage, (file) async {
        if (file.contains("editingBase64,")) {
          String uid = const Uuid().v1();

          String imgStr = RichTextFormat().getImage(file);

          String imageIsExistId = await ImageService().imageIsExist(imgStr);

          if (imageIsExistId != "-1") {
            uid = imageIsExistId;
          } else {
            await ImageService().saveImg(uid, imgStr);
          }

          String httpImg = "${APIHttpController.prefixUrl}://${APIHttpController.databaseDomainStr}/images/$uid";
          uploadedfileList.add(httpImg);
        } else {
          uploadedfileList.add(file);
        }
      });
      fileMessageStr = listToListStr(uploadedfileList);
    }

    int postIndex = await PostService().createPost(userData.uid, mainMessage, fileMessageStr, postTypeBoard.type);

    PostModel post = PostModel(
      id: postIndex,
      createdBy: userData.uid,
      type: postTypeBoard.type,
      mainMessage: mainMessage,
      fileMessage: uploadedfileList,
      commentCount: 0,
      postTime: DateTime.now().toUtc().toString(),
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
    int dataIndex, {
    bool autoFocusKeyBoard = true,
  }) async {
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

    /// 詳細ページ開く
    PostDetailPage(
      dataIndex: dataIndex,
      postListController: postListController,
      autoFocusKeyBoard: autoFocusKeyBoard,
    ).show(context);
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
      choiceData.loginUserIsGood = false;
      await PostService().updatePostGood(choiceData.id);
    } else {
      ///いいねひく
      choiceData.good++;
      choiceData.loginUserIsGood = true;
      await PostService().updatePostGood(choiceData.id, userUID: userData.uid);
      String message = '"${ref.read(loginUserData.notifier).state.name}"對您的文章按了讚';

      NotificationModel notification = NotificationModel.empty();
      notification.userUid = ref.read(loginUserData.notifier).state.uid;
      notification.otherUserUid = choiceData.postUserInfo.uid;
      notification.type = 0;
      notification.title = message;
      notification.postId = choiceData.id;
      notification.sendNotificationuserInfo = ref.read(loginUserData.notifier).state;

      NotificationService().createNotification(notification: notification);
      FirebaseNotificationService().sendNotification(
        message: message,
        sendto: notificationToken,
        notifiactionInfo: notification,
      );
    }

    ///文章リストのいいね更新する
    if (postListController != null) {
      ref.read(postListController.notifier).editData(dataIndex, choiceData);
    }

    render();
  }

  ///リストいいねする
  Future<void> listPostGoodOnChange(
    bool isGooded, {
    required int dataIndex,
    required PostModel postData,
    required StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController,
  }) async {
    ProfileData userData = ref.watch(loginUserData);
    notificationToken = await UserService().requestUserNotificationTokenByUID(postData.postUserInfo.uid);

    if (isGooded) {
      ///いいねたす
      postData.good--;
      postData.loginUserIsGood = false;
      await PostService().updatePostGood(postData.id);
    } else {
      ///いいねひく
      postData.good++;
      postData.loginUserIsGood = true;
      await PostService().updatePostGood(postData.id, userUID: userData.uid);
      String message = '"${ref.read(loginUserData.notifier).state.name}"對您的文章按了讚';

      NotificationModel notification = NotificationModel.empty();
      notification.userUid = ref.read(loginUserData.notifier).state.uid;
      notification.otherUserUid = postData.postUserInfo.uid;
      notification.type = 0;
      notification.title = message;
      notification.postId = postData.id;
      notification.sendNotificationuserInfo = ref.read(loginUserData.notifier).state;

      NotificationService().createNotification(notification: notification);
      FirebaseNotificationService().sendNotification(
        message: message,
        sendto: notificationToken,
        notifiactionInfo: notification,
      );
    }

    ///文章リストのいいね更新する
    if (postListController != null) {
      ref.read(postListController.notifier).editData(dataIndex, postData);
    }

    render();
  }

  ///コメント作成
  Future<bool> postCommentUpdate({
    required String message,
    required int dataIndex,
  }) async {
    PostCommentTextEditorModel data = ref.read(postCommentListControllerProvider).listData[dataIndex].copyWith();

    if (message.replaceAll(" ", "") == "" || data.message == message) {
      return false;
    }

    ///編集
    await PostService().updatePostComment(id: data.uid, mainMessage: message);
    ref.read(postCommentListControllerProvider).listData[dataIndex].message = message;
    render();

    return true;
  }

  ///コメント作成
  Future<bool> postCommentCreate({
    required String message,
    required int dataIndex,
    required StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>? postListController,
  }) async {
    if (message.replaceAll(" ", "") == "") {
      return false;
    }
    PostModel choiceData = ref.read(choicedPostProvider);
    ProfileData userData = ref.watch(loginUserData);
    int uid = await PostService().createPostComment(postUID: choiceData.id, userUID: userData.uid, message: message);

    PostCommentTextEditorModel sdsat = PostCommentTextEditorModel(
      uid: uid,
      postId: ref.read(choicedPostProvider.notifier).state.id,
      userUid: userData.uid,
      message: message,
      postTime: DateTime.now().toUtc().toString(),
      commentUserInfo: userData,
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

    return true;
  }

  ///コメント編集
  Future<void> postCommentEdit({required PostCommentTextEditorModel data}) async {
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

  String listToListStr(List<String> list) {
    StringBuffer result = StringBuffer();
    result.write('[');

    for (int i = 0; i < list.length; i++) {
      result.write('"${list[i]}"');
      if (i < list.length - 1) {
        result.write(',');
      }
    }

    result.write(']');
    return result.toString();
  }
}
