import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/home/coursePage/course_edit_page/course_edit_page.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../../models/course_model.dart';
import '../../../utilities/inputField/base_input.dart';
import '../../../utilities/style/screen_size.dart';

enum EdiType {
  detail,
  chapter,
}

class CourseRichTextEdit extends BaseFadeScalePage {
  final Function courseEditPageRender;
  final EdiType ediType;

  CourseRichTextEdit({
    this.ediType = EdiType.detail,
    required this.courseEditPageRender,
  });
  @override
  Widget build(WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    QuillEditorController controller = QuillEditorController();
    return CommonScaffold(
      type: PageType.main,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
        child: Column(
          children: [
            BaseTopBar(
              rightWidget: MainBtn(
                title: "保存",
                onPress: () async {
                  String richTextContent = await controller.getText();
                  if (ediType == EdiType.chapter) {
                    String title = titleController.text;
                    print("titleController: $title  richTextContent $richTextContent");
                    List<CourseChapterInfo> chapterList = ref.read(courseEditChapterList.notifier).state;
                    CourseChapterInfo createChapter =
                        CourseChapterInfo(chapter: chapterList.length + 1, chapterName: title, content: [richTextContent]);

                    chapterList.add(createChapter);
                    ref.read(courseEditChapterList.notifier).update((state) => chapterList);
                  } else {
                    print("richTextContent $richTextContent");
                    ref.read(courseDetailContent.notifier).update((state) => richTextContent);
                  }
                  courseEditPageRender();
                  closePage();
                },
              ),
            ),
            Visibility(
              visible: EdiType.chapter == ediType,
              child: BaseInputField(
                hintText: "標題",
                hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize24),
                inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize24),
                controller: titleController,
              ),
            ),
            Expanded(
              child: RichTextEditor(controller: controller, content: ""),
            ),
          ],
        ),
      ),
    );
  }
}
