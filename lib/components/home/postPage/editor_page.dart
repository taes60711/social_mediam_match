import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import '../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../utilities/rich_text_editor.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class PostEditorPage extends BaseFadeScalePage {
  QuillEditorController quillEditorController = QuillEditorController();
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          leftWidget: GestureDetector(
            onTap: () {
              closePage();
            },
            child: Container(
              width: ScreenSize.fitPxWidth(40),
              height: ScreenSize.fitPxWidth(40),
              color: Colors.transparent,
              child: Center(
                child: Icon(
                  Icons.close,
                  size: ScreenSize.fontSize18,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
          rightWidget: MainBtn(
            onPress: () {},
            title: "投稿",
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "標題",
                  style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize24),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RichTextEditor(
                    content: "",
                    controller: quillEditorController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
