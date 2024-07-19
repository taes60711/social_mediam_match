import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../pageManager/setting/route_controller.dart';
import '../../../provider/post/edit_page_model.dart';
import '../../../provider/post/my_post_view_model.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/basic_top_bar.dart';

QuillEditorController controller = QuillEditorController();
TextEditingController titleInputController = TextEditingController();

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext postContext = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postContext'];
    int postBoradType = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postBoradType'] ?? -1;

    return ChangeNotifierProvider.value(
      value: postContext.read<BaseAPIListProvider<PostModel>>(),
      child: Builder(builder: (context) {
        PostModel postData = postContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
        titleInputController.text = postData.title;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTopBar(
                  backFunc: () async {
                    String content = await controller.getText();
                    String title = titleInputController.text;
                    if (postData.mainMessage != content || postData.title != title) {
                      EditPageModel().editorExitCheck();
                    } else {
                      RouteOptions.pop();
                    }
                  },
                  title: "文章編輯",
                  rightWidget: GestureDetector(
                    onTap: () async {
                      await controller.getText().then(
                        (content) {
                          if (titleInputController.text == "" || content == "") {
                            EditPageModel().createPostCheck(titleInputController.text, content);
                          } else {
                            postData.id == -1
                                ? PostViewModel(postContext: postContext)
                                    .createPost(title: titleInputController.text, msg: content, type: postBoradType)
                                : MyPostViewModel(myPostContext: postContext).updatePost(updateMsg: content);
                            RouteOptions.pop();
                          }
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 10),
                      width: 80,
                      height: 35,
                      child: Text(postData.id == -1 ? "新增" : ProfileString().updateButtonText),
                    ),
                  ),
                ),
                TitleInput(title: 'Title', textController: titleInputController),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: RichTextEditor(
                      content: postData.mainMessage,
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
