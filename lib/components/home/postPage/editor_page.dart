import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import '../../../models/rich_text_format.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    PostState postState = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postState'];
    LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
    int type = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['type'];
    QuillEditorController controller = QuillEditorController();
    TextEditingController titleController = TextEditingController();
    Widget userComponent = SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const Text("投稿"),
                GestureDetector(
                  onTap: () async {
                    String content = await controller.getText();
                    await postState.createPost(userData.uid, titleController.text, content, type);
                    Navigator.pop(context);
                  },
                  child: const Text("送出"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TitleInput(title: '標題', textController: titleController),
          Expanded(
            child: SingleChildScrollView(
              child: RichTextEditor(
                content: "",
                controller: controller,
              ),
            ),
          )
        ],
      ),
    );
    return Scaffold(body: userComponent);
  }
}
