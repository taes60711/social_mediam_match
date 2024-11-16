// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/inputField/mutl_input.dart';

import '../../../models/feed_back_model.dart';
import '../../../services/feed_back_service.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class CustomServicePage extends BaseBottomSheet {
  @override
  double buildHeight() {
    return 0.93;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  @override
  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          leftWidget: downCloseBtn(onPress: () {
            closePage();
          }),
          title: "問題回報",
          rightWidget: MainBtn(
            onPress: () async {
              print("send title ${titleController.text} email ${mailController.text} content ${contentController.text}");
              FeedBackModel feedBack =
                  FeedBackModel(title: titleController.text, email: mailController.text, content: contentController.text);
              bool isSucess = await UserFeedBackService().createFeedBack(feedBack);
              if (isSucess) {
                ConfirmDilaog(
                  btnAmount: 1,
                  title: "提示",
                  content: "感謝回覆",
                  conirmFunc: () {
                    closePage();
                  },
                ).show(context);
              }
            },
            title: "送出",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              inputField(hintText: "標題", editingController: titleController, fontSzie: ScreenSize.fontSize24),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              inputField(hintText: "信箱", editingController: mailController),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              MultInput(controller: contentController, hintText: "回報內容", minLines: 15, maxLines: 15),
            ],
          ),
        )
      ],
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize18;
    return BaseInputField(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
      controller: editingController,
    );
  }
}
