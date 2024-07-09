// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/pagemanager/setting/route_controller.dart';
import 'package:social_mediam_match/provider/course_provider.dart';

QuillEditorController controller = QuillEditorController();

class CourseRichTextEdit extends StatelessWidget {
  final BuildContext courseContext;
  final int? index;
  final String? prStory;
  const CourseRichTextEdit({
    super.key,
    this.index,
    this.prStory,
    required this.courseContext,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    return Column(
      children: [
        BaseTopBar(
          title: prStory != null ? "詳細介紹" : "章節$index",
          rightWidget: CustomButton(
              width: 55,
              verticalMargin: 2,
              borderRadius: 8,
              title: "保存",
              backgroundColor: normalBgColor2.withOpacity(0.8),
              onPress: () async {
                String editedContent = await controller.getText();
                if (prStory != null) {
                  courseContext.read<CourseProvider>().prStoryOnChange(editedContent);
                } else {
                  String chapterFormattedStr = '{"text":"${titleController.text}","url":"$editedContent"}';
                  courseContext.read<CourseProvider>().addChapterContent(index ?? -1, chapterFormattedStr);
                }

                RouteOptions.pop();
              }),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                prStory != null ? Container() : TitleInput(title: "標題", textController: titleController),
                RichTextEditor(controller: controller, content: prStory ?? ""),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
