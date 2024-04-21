import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../models/rich_text_format.dart';

class RichTextEditor extends StatelessWidget {
  final String content;
  final QuillEditorController controller;
  const RichTextEditor({required this.controller, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final customToolBarList = [ToolBarStyle.color, ToolBarStyle.size, ToolBarStyle.video, ToolBarStyle.link, ToolBarStyle.image];
    double fontSize = 18;
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
          text: RichTextFormat(htmlString: content).WidgetToEditorHtml(content),
          controller: controller,
          minHeight: 1,
          textStyle: TextStyle(fontSize: fontSize),
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
