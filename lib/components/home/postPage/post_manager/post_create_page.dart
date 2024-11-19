import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';

import '../../../../models/post_model.dart';

import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';
import '../../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/rich_text_editor.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';

class PostCreatePage extends BaseFadeScalePage {
  PostBoard? postBoard;
  PostCreatePage({this.postBoard});

  QuillEditorController quillEditorController = QuillEditorController();
  TextEditingController titleController = TextEditingController();

  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              onPress: () async {
                String postTitle = titleController.text;
                String postContent = await quillEditorController.getText();
                if (postTitle == "" || postContent == "") {
                  String content = "";
                  if (postTitle == "" && postContent == "") {
                    content = "\"標題\"不得為空\n\"內文\"不得為空";
                  } else if (postTitle == "") {
                    content = "\"標題\"不得為空";
                  } else if (postContent == "") {
                    content = "\"內文\"不得為空";
                  }

                  ConfirmDilaog(title: '警告', content: content).show(context);
                  return;
                }

                viewModel.postCreate(
                  postTitle: titleController.text,
                  postContent: await quillEditorController.getText(),
                  postBoard: postBoard,
                );
              },
              title: "投稿",
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseInputField(
                    hintText: "標題",
                    hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize24),
                    inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize24),
                    controller: titleController,
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(10)),
                  PostBoardChoicedLabel(postBoard: postBoard),
                  SizedBox(height: ScreenSize.fitPxHeight(15)),
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
      ),
    );
  }
}

class PostBoardChoicedLabel extends ConsumerStatefulWidget {
  final PostBoard? postBoard;

  const PostBoardChoicedLabel({super.key, this.postBoard});

  @override
  ConsumerState<PostBoardChoicedLabel> createState() => _PostBoardChoicedLabelState();
}

class _PostBoardChoicedLabelState extends ConsumerState<PostBoardChoicedLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "看板",
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(10)),
        widget.postBoard != null
            ? Text(
                widget.postBoard!.name,
                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
              )
            : MainBtn(
                onPress: () {
                  PostBoardChoiceBottomSheet().show(context);
                },
                child: boardContaienr(
                  Row(
                    children: [
                      Text(
                        ref.watch(postCreateChoiceBoard).name,
                        style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Icon(
                        FontAwesomeIcons.caretDown,
                        size: ScreenSize.fontSize16,
                        color: AppColors.whiteColor,
                      )
                    ],
                  ),
                )),
      ],
    );
  }

  Widget boardContaienr(Widget child) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxHeight(5),
          vertical: ScreenSize.fitPxHeight(1),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.greyColor98,
        ),
        child: child);
  }
}

class PostBoardChoiceBottomSheet extends BaseBottomSheet {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  List<PostBoard> item = [];
  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    item = ref.read(allPostBoardListData.notifier).state;

    int choicedItemsIndex = item.indexWhere((element) => element.id == ref.read(postCreateChoiceBoard.notifier).state.id);

    if (choicedItemsIndex != -1) {
      scrollController.jumpToItem(choicedItemsIndex);
    }

    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 50,
      onSelectedItemChanged: (int index) {
        ref.read(postCreateChoiceBoard.notifier).update((state) => item[index]);
        render();
      },
      children: item
          .map(
            (e) => Center(
              child: Text(
                e.name,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          )
          .toList(),
    );
  }
}
