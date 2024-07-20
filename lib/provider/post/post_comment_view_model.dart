// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/post/post_comment_provider.dart';

import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/custom_button.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../pageManager/setting/route_controller.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';

class PostCommentViewModel {
  BuildContext postCommentContext;
  PostCommentViewModel({required this.postCommentContext});

  void editerStatusOnChange(PostCommentTextEditorModel editorData) {
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().onChoiceData(choicedData: editorData);
    editorData.isEditor = !editorData.isEditor;
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().editData(updatedData: editorData);
  }

  Future<void> commetMessageOnChange(PostCommentTextEditorModel editorData, String changeMessage) async {
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().onChoiceData(choicedData: editorData);
    await PostService().updatePostComment(id: editorData.uid, mainMessage: changeMessage);

    editorData.message = changeMessage;
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().editData(updatedData: editorData);
    editerStatusOnChange(editorData);
  }

  Future<void> commetMessageOnDelete(PostCommentTextEditorModel choiceData) async {
    await PostService().deletePostComment(id: choiceData.uid);
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().deleteData(choiceData: choiceData);
  }

  Future<void> deleteCommentPostCheck(PostCommentTextEditorModel choiceData) {
    return showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 150,
            height: 160,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text('確定要刪除該篇留言嗎?'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextBtn(
                        title: '取消',
                        titleColor: normalTextColor,
                        btnColor: hintTextColor,
                        onPress: () {
                          RouteOptions.pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextBtn(
                        title: '確認',
                        titleColor: normalTextColor,
                        btnColor: normalBgColor,
                        onPress: () async {
                          commetMessageOnDelete(choiceData);
                          RouteOptions.pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> commetMessageOnCreate({required int postUID, required String message}) async {
    LoginUser loginUserData = postCommentContext.read<UserProvider>().userData;
    int uid = await PostService().createPostComment(postUID: postUID, userUID: loginUserData.uid, message: message);
    DateTime dateUtc = DateTime.now().toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());
    PostCommentTextEditorModel commentTextEditorModel = PostCommentTextEditorModel(
      uid: uid,
      postId: postUID,
      userUid: loginUserData.uid,
      message: message,
      postTime: formattedTime,
      commentUserInfo: loginUserData,
      isEditor: false,
      textEditingController: TextEditingController(),
    );
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().createData(createdData: commentTextEditorModel);
    postCommentContext.read<PostCommentProvider>().afterPostCeate();
  }
}
