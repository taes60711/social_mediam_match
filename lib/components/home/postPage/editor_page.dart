import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../../pageManager/setting/route_controller.dart';
import '../../../provider/post/my_post_view_model.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/basic_top_bar.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext postContext = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postContext'];

    QuillEditorController controller = QuillEditorController();
    return ChangeNotifierProvider.value(
      value: postContext.read<BaseAPIListProvider<PostModel>>(),
      child: Builder(builder: (context) {
        PostModel postData = postContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTopBar(
                  backFunc: () => RouteOptions.pop(),
                  title: postData.id == -1 ? "" : postData.title,
                  rightWidget: GestureDetector(
                    onTap: () async {
                      await controller.getText().then((content) {
                        postData.id == -1
                            ? print("create Post")
                            : MyPostViewModel(myPostContext: postContext).updatePost(updateMsg: content);
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 10),
                      width: 80,
                      height: 35,
                      child: Text(ProfileString().updateButtonText),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: RichTextEditor(
                      content: postData.mainMessage,
                      controller: controller,
                    ),
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                //   child: Text(
                //     "*內文不得為空",
                //     style: TextStyle(color: Colors.red),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
