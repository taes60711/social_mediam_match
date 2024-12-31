import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_mediam_match/components/utilities/dialog/base_dialog.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../../global.dart';
import '../../utilities/lodaing_dialog.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class UserProfileSharePage extends BaseDialog {
  String shareUrl = "";
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Future<void> initState(WidgetRef ref) async {
    ProfileData userData = ref.read(loginUserData.notifier).state;
    shareUrl = "https://$domain/profile/${userData.uid}";
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSize.fitPxHeight(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(30)),
      decoration: BoxDecoration(
        color: AppColors.greyColor54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          /// Title
          Row(
            children: [
              const Expanded(child: SizedBox(width: 1)),
              Expanded(
                child: Text(
                  "分享",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize22),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: MainBtn(
                    onPress: () {
                      closePage();
                    },
                    child: Container(
                      width: ScreenSize.fitPxWidth(40),
                      height: ScreenSize.fitPxWidth(40),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                        size: ScreenSize.fontSize22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// QrCode
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(30)),
            child: Screenshot(
              controller: screenshotController,
              child: QrImageView(
                data: shareUrl,
                backgroundColor: AppColors.whiteColor,
                size: ScreenSize.fitPxWidth(200),
              ),
            ),
          ),

          /// Btn
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxWidth(25),
            ),
            child: Column(
              children: [
                MainBtn(
                  isFullWidth: true,
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                  backgroundColor: AppColors.orangeColor,
                  onPress: () async {
                    Clipboard.setData(ClipboardData(text: shareUrl));
                    Toast().showBottom(msg: "已複製");
                  },
                  title: "複製連結",
                ),
                SizedBox(
                  height: ScreenSize.fitPxWidth(10),
                ),
                MainBtn(
                  isFullWidth: true,
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                  backgroundColor: AppColors.greyColor130,
                  onPress: () async {
                    await screenshotController.capture().then((Uint8List? image) async {
                      if (image != null) {
                        final directory = await getApplicationDocumentsDirectory();
                        final imagePath = await File('${directory.path}/image.png').create();
                        await imagePath.writeAsBytes(image);
                        LoadingDialog().show();
                        await Share.shareFiles([imagePath.path]);
                        LoadingDialog().close();
                      }
                    });
                  },
                  title: "QrCode 分享",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
