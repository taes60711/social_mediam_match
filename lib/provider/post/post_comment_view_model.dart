import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/custom_button.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global.dart';
import '../../models/post_model.dart';
import '../../pageManager/setting/route_controller.dart';

class PostCommentViewModel {
  BuildContext postCommentContext;
  PostCommentViewModel({required this.postCommentContext});

  void editerStatusOnChange(PostCommentTextEditorModel editorData) {
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().onChoiceData(choicedData: editorData);
    editorData.isEditor = !editorData.isEditor;
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().editData(updatedData: editorData);
  }

  void commetMessageOnChange(PostCommentTextEditorModel editorData, String changeMessage) {
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().onChoiceData(choicedData: editorData);
    editorData.message = changeMessage;
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().editData(updatedData: editorData);
    editerStatusOnChange(editorData);
  }

  void commetMessageOnDelete(PostCommentTextEditorModel choiceData) {
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
                  child: Text('確定要刪除該篇文章嗎?'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: '取消',
                        titleColor: normalTextColor,
                        backgroundColor: hintTextColor,
                        onPress: () {
                          RouteOptions.pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        title: '確認',
                        titleColor: normalTextColor,
                        backgroundColor: normalBgColor,
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

  void commetMessageOnCreate(PostCommentTextEditorModel choiceData) {
    postCommentContext.read<BaseAPIListProvider<PostCommentTextEditorModel>>().createData(createdData: choiceData);
  }
}
