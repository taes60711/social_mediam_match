// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/lodaing_dialog.dart';

import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../../../models/course_model.dart';
import '../../../../../models/rich_text_format.dart';
import '../../../../../provider/course/corse_edit_view_model.dart';

import '../../../../utilities/dialog/confirm_dialog.dart';
import '../../../../utilities/inputField/base_input.dart';
import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/screen_size.dart';

enum CreateEdiType {
  detail,
  chapter,
}

class CourseRichTextCreate extends BaseFadeScalePage {
  final Function courseEditPageRender;
  final CreateEdiType ediType;

  CourseRichTextCreate({
    this.ediType = CreateEdiType.detail,
    required this.courseEditPageRender,
  });
  TextEditingController titleController = TextEditingController();
  QuillEditorController courserController = QuillEditorController();

  @override
  Future<void> initState(WidgetRef ref) async {}

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
        child: Column(
          children: [
            BaseTopBar(
              backFunc: () async {
                if (await closeIsEditEdCheck()) {
                  ConfirmDilaog(
                      title: '提示',
                      content: '正在編輯中, 確定要離開嗎？',
                      conirmFunc: () {
                        closePage();
                      }).show(context);
                } else {
                  closePage();
                }
              },
              rightWidget: MainBtn(
                title: "保存",
                onPress: () async {
                  LoadingDialog().show();
                  String richTextContent = await courserController.getText();

                  if (sendBeforeCheck(richTextContent)) {
                    if (ediType == CreateEdiType.chapter) {
                      String title = titleController.text;
                      print("titleController: $title  richTextContent $richTextContent");
                      String fomattedContent = await RichTextFormat(htmlString: richTextContent).sendPostImgFormat();
                      List<CourseChapterInfo> chapterList = ref.read(courseEditChapterList.notifier).state;
                      CourseChapterInfo createChapter =
                          CourseChapterInfo(chapter: chapterList.length + 1, chapterName: title, content: [fomattedContent]);

                      chapterList.add(createChapter);
                      ref.read(courseEditChapterList.notifier).update((state) => chapterList);
                    } else {
                      print("richTextContent $richTextContent");
                      String fomattedContent = await RichTextFormat(htmlString: richTextContent).sendPostImgFormat();

                      ref.read(courseDetailContent.notifier).update((state) => fomattedContent);
                    }
                    LoadingDialog().close();
                    courseEditPageRender();
                    closePage();
                  }
                },
              ),
            ),
            Visibility(
              visible: CreateEdiType.chapter == ediType,
              child: BaseInputField(
                hintText: "標題",
                hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize24),
                inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize24),
                controller: titleController,
              ),
            ),
            Expanded(
              child: RichTextEditor(controller: courserController, content: ""),
            ),
          ],
        ),
      ),
    );
  }

  ///　クロース前に編集したことある確認
  Future<bool> closeIsEditEdCheck() async {
    bool isEdited = false;
    String richTextContent = await courserController.getText();
    if (ediType == CreateEdiType.chapter) {
      if (titleController.text != "" || richTextContent != "") {
        isEdited = true;
      }
    } else {
      if (richTextContent != "") {
        isEdited = true;
      }
    }

    return isEdited;
  }

  ///　投稿前に空欄あるのチェック
  bool sendBeforeCheck(String content) {
    bool isOK = true;
    String errMsg = "";
    if (ediType == CreateEdiType.chapter) {
      if (titleController.text.replaceAll(" ", "") == "") {
        errMsg += "\"標題\"不得為空";
        isOK = false;
      }
    }
    if (content.replaceAll(" ", "") == "") {
      if (errMsg != "") errMsg += "\n";
      errMsg += "\"內文\"不得為空";
      isOK = false;
    }

    if (!isOK) {
      LoadingDialog().close();
      ConfirmDilaog(title: '警告', content: errMsg).show(context);
    }

    return isOK;
  }
}
