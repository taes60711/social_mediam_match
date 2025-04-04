// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../models/feed_back_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/feed_back_service.dart';
import '../bottomSheets/base_bottom_sheet.dart';
import '../main_button.dart';
import '../style/app_colors.dart';
import '../style/screen_size.dart';

class ReportBtmSheet extends BaseBottomSheet {
  String reportTitle;
  ReportBtmSheet({required this.reportTitle});

  @override
  double buildHeight() {
    return 0.58;
  }

  List<String> reportReasons = [
    "色情或不當內容",
    "暴力或血腥內容",
    "仇恨言論或歧視",
    "騷擾或霸凌他人",
    "違反個資或隱私",
    "惡意廣告或垃圾訊息",
    "假訊息或不實資訊",
    "侵權行為",
    "違反平台規定",
    "其他",
  ];

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        Text(
          '請選擇檢舉理由',
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        Column(
          children: reportReasons.asMap().entries.map((e) {
            int index = e.key;
            String title = e.value;
            return index == reportReasons.length - 1
                ? reportMainBtn(
                    ref,
                    reportTitle: reportTitle,
                    reportReason: title,
                    needBorder: false,
                  )
                : reportMainBtn(
                    ref,
                    reportTitle: reportTitle,
                    reportReason: title,
                  );
          }).toList(),
        )
      ],
    );
  }

  Widget reportMainBtn(WidgetRef ref, {required String reportTitle, required String reportReason, bool needBorder = true}) {
    return MainBtn(
      onPress: () {
        ConfirmDilaog(
            title: '檢舉',
            content: '確定要檢舉嗎？',
            conirmFunc: () async {
              ProfileData userData = ref.read(loginUserData);
              FeedBackModel feedBack = FeedBackModel(
                title: reportTitle,
                email: userData.uid,
                content: '檢舉了 : "$reportReason"',
              );
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
            }).show(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.fitPxWidth(9),
        ),
        width: ScreenSize.width,
        alignment: Alignment.center,
        decoration: needBorder
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .4, color: AppColors.greyColor130),
                ),
              )
            : null,
        child: Text(
          reportReason,
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
        ),
      ),
    );
  }
}
