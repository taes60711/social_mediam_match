import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main_button.dart';
import '../style/screen_size.dart';
import '../style/app_colors.dart';
import 'base_dialog.dart';

class ConfirmDilaog extends BaseDialog {
  String title;
  String content;
  Function? conirmFunc;
  Function? cancelFunc;
  int btnAmount;

  ConfirmDilaog({required this.title, required this.content, this.cancelFunc, this.conirmFunc, this.btnAmount = 2});
  @override
  Widget build(WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(25),
        vertical: ScreenSize.fitPxHeight(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(30)),
      decoration: BoxDecoration(
        color: AppColors.greyColor54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize22),
          ),
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize16),
          ),
          SizedBox(height: ScreenSize.fitPxWidth(25)),
          btnAmount == 1 ? oneBtnWidget() : twoBtnWidget(),
        ],
      ),
    );
  }

  Widget oneBtnWidget() {
    return MainBtn(
      isFullWidth: true,
      padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
      backgroundColor: AppColors.orangeColor,
      onPress: () {
        if (conirmFunc != null) {
          conirmFunc!();
        }
        closePage();
      },
      title: "確認",
    );
  }

  Widget twoBtnWidget() {
    return Row(
      children: [
        Expanded(
          child: MainBtn(
            backgroundColor: AppColors.black37,
            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
            onPress: () {
              if (cancelFunc != null) {
                cancelFunc!();
              }
              closePage();
            },
            title: "取消",
          ),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(15)),
        Expanded(
          child: MainBtn(
            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
            backgroundColor: AppColors.orangeColor,
            onPress: () {
              if (conirmFunc != null) {
                conirmFunc!();
              }
              closePage();
            },
            title: "確認",
          ),
        ),
      ],
    );
  }
}
