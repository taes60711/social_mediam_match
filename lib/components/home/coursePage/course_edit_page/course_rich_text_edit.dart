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
  final int index;
  const CourseRichTextEdit({super.key, required this.index, required this.courseContext});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          BaseTopBar(
            title: "課程詳細",
            rightWidget: CustomButton(
                width: 55,
                verticalMargin: 2,
                borderRadius: 8,
                title: "保存",
                backgroundColor: normalBgColor2.withOpacity(0.8),
                onPress: () async {
                  String editedContent = await controller.getText();
                  String chapterFormattedStr = '{"text":"${titleController.text}","url":"$editedContent"}';
                  courseContext.read<CourseProvider>().addChapterContent(index, chapterFormattedStr);
                  RouteOptions.pop();
                }),
          ),
          TitleInput(title: "標題", textController: titleController),
          SingleChildScrollView(
            child: RichTextEditor(controller: controller, content: ""),
          ),
        ],
      ),
    );
  }
}
