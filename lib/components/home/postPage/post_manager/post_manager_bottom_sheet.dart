import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../../../models/post_model.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/post_service.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';
import 'post_editor_page.dart';

class PostManagerBtmSheet extends BaseBottomSheet {
  StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>> postListController;

  int dataIndex;
  PostManagerBtmSheet(this.postListController, {required this.dataIndex});

  @override
  double buildHeight() {
    return 0.3;
  }

  late PostViewModel viewModel;
  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        managerPageMainBtn(
            iconData: FontAwesomeIcons.penToSquare,
            text: "編輯文章",
            onPress: () {
              PostEditorPage(dataIndex: dataIndex, postListController).show(context);
            }),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        managerPageMainBtn(
          iconData: FontAwesomeIcons.trash,
          text: "刪除文章",
          onPress: () {
            ConfirmDilaog(
              title: "警告",
              content: "確定要刪除該文章?",
              conirmFunc: () async {
                bool isSucess = await PostService().deletePost(ref.read(choicedPostProvider.notifier).state.id);
                if (isSucess) {
                  ref.read(postListController.notifier).removeData(dataIndex);
                  render();
                  closePage();
                }
              },
            ).show(context);
          },
        ),
      ],
    );
  }

  Widget managerPageMainBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
          vertical: ScreenSize.fitPxWidth(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor130,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          children: [
            Icon(iconData, color: AppColors.whiteColor),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
