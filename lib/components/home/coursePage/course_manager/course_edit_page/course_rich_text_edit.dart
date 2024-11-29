// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../../../models/course_model.dart';
import '../../../../../provider/course/course_provider.dart';
import '../../../../utilities/dialog/confirm_dialog.dart';
import '../../../../utilities/inputField/base_input.dart';
import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/screen_size.dart';

enum EdiType {
  detail,
  chapter,
}

class CourseRichTextEdit extends BaseFadeScalePage {
  final Function courseEditPageRender;
  final EdiType ediType;

  ///詳細内容用
  final String? content;

  ///チャプター用
  final CourseChapterInfo? courseChapterInfo;
  final int? courseChaterIndex;

  CourseRichTextEdit({
    this.ediType = EdiType.detail,
    required this.courseEditPageRender,
    this.courseChapterInfo,
    this.courseChaterIndex,
    this.content,
  });
  TextEditingController titleController = TextEditingController();
  QuillEditorController courserController = QuillEditorController();
  String realContent = "";
  @override
  Future<void> initState(WidgetRef ref) async {
    if (courseChapterInfo != null && ediType == EdiType.chapter) {
      titleController.text = courseChapterInfo!.chapterName;
      courserController.setText(courseChapterInfo!.content[0]);
      realContent = courseChapterInfo!.content[0];
    } else {
      courserController.setText(content ?? "");
      realContent = content ?? "";
    }

    render();
  }

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
                      content: '正在編輯中　確定要離開嗎？',
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
                  String richTextContent = await courserController.getText();
                  if (sendBeforeCheck(richTextContent)) {
                    if (ediType == EdiType.chapter) {
                      String title = titleController.text;
                      print("titleController: $title  richTextContent $richTextContent");
                      List<CourseChapterInfo> chapterList = ref.read(courseEditChapterList.notifier).state;

                      courseChapterInfo!.chapterName = title;
                      courseChapterInfo!.content = [richTextContent];
                      chapterList[courseChaterIndex ?? -1] = courseChapterInfo!;

                      ref.read(courseEditChapterList.notifier).update((state) => chapterList);
                    } else {
                      print("richTextContent $richTextContent");
                      ref.read(courseDetailContent.notifier).update((state) => richTextContent);
                    }
                    courseEditPageRender();
                    closePage();
                  }
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
              child: RichTextEditor(controller: courserController, content: realContent),
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

    if (ediType == EdiType.chapter) {
      if (courseChapterInfo != null) {
        if (titleController.text != courseChapterInfo!.chapterName || richTextContent != courseChapterInfo!.content[0]) {
          isEdited = true;
        }
      }
    } else {
      if (richTextContent != content) {
        isEdited = true;
      }
    }

    return isEdited;
  }

  ///　投稿前に空欄あるのチェック
  bool sendBeforeCheck(String content) {
    bool isOK = true;
    String errMsg = "";
    if (ediType == EdiType.chapter) {
      if (titleController.text == "") {
        errMsg += "\"標題\"不得為空";
        isOK = false;
      }
    }
    if (content == "") {
      if (errMsg != "") errMsg += "\n";
      errMsg += "\"內文\"不得為空";
      isOK = false;
    }

    if (!isOK) {
      ConfirmDilaog(title: '警告', content: errMsg).show(context);
    }

    return isOK;
  }
}
