import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class RichTextEditor extends StatelessWidget {
  String content;
  RichTextEditor({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final QuillEditorController controller = QuillEditorController();
    final customToolBarList = [ToolBarStyle.color, ToolBarStyle.size, ToolBarStyle.video, ToolBarStyle.link, ToolBarStyle.image];
    return Column(
      children: [
        ToolBar.scroll(
          toolBarColor: Colors.cyan.shade50,
          controller: controller,
          direction: Axis.horizontal,
          toolBarConfig: customToolBarList,
          customButtons: [
            InkWell(
              onTap: () async {
                print("customButtons");
              },
              child: const Icon(Icons.favorite),
            ),
          ],
        ),
        QuillHtmlEditor(
          text: content,
          controller: controller,
          minHeight: 1,
          textStyle: TextStyle(fontSize: 18),
          loadingBuilder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 0.4,
            ));
          },
        ),
      ],
    );
  }
}
