// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/services/post_service.dart';
import '../../../../models/post_model.dart';
import '../../../../models/rich_text_format.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/dialog/cant_touch_loading_dialog.dart';
import '../../../utilities/dialog/confirm_dialog.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/rich_text_editor.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';

class PostEditorPage extends BaseFadeScalePage {
  StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>> postListController;

  int dataIndex;
  PostEditorPage(this.postListController, {required this.dataIndex});
  QuillEditorController quillEditorController = QuillEditorController();
  TextEditingController titleController = TextEditingController();
  String typeName = "";
  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    titleController.text = ref.read(choicedPostProvider.notifier).state.title;
    typeName = ref
        .read(allPostBoardListData)
        .firstWhere(
          (e) => e.id == ref.read(choicedPostProvider.notifier).state.type,
          orElse: () => PostBoard(),
        )
        .chineseName;
    viewModel = PostViewModel(ref: ref, context: context, render: render);
    render();
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
              onTap: () async {
                if (await postExitCheck()) {
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
              child: Container(
                width: ScreenSize.fitPxWidth(40),
                height: ScreenSize.fitPxWidth(40),
                color: AppColors.transparent,
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
                CanTouchScreenLoadingDialog().show();
                String postContent = await quillEditorController.getText();
                String fomattedContent = await RichTextFormat(htmlString: postContent).sendPostImgFormat();

                if (viewModel.postCreateBeforCheck(postTitle: postTitle, postContent: postContent)) {
                  PostModel post = ref.read(choicedPostProvider.notifier).state;

                  bool isSucess = await PostService().updatePost(
                    postId: post.id,
                    title: postTitle,
                    mainMessage: fomattedContent,
                  );

                  if (isSucess) {
                    post.title = postTitle;
                    post.mainMessage = fomattedContent;
                    ref.read(postListController.notifier).editData(dataIndex, post);

                    render();

                    closePage();
                  }
                }
                CanTouchScreenLoadingDialog().close();
              },
              title: "更新",
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
                  Text(
                    "看板 $typeName",
                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(15)),
                  Expanded(
                    child: RichTextEditor(
                      content: ref.read(choicedPostProvider.notifier).state.mainMessage,
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

  Future<bool> postExitCheck() async {
    bool isEdit = false;
    String postTitle = titleController.text;
    String postContent = await quillEditorController.getText();

    String fomattedContent = await RichTextFormat(htmlString: postContent).sendPostImgFormat();
    if (postTitle != ref.read(choicedPostProvider.notifier).state.title ||
        fomattedContent != ref.read(choicedPostProvider.notifier).state.mainMessage) {
      isEdit = true;
    }
    return isEdit;
  }
}
