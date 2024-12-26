import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_mediam_match/components/utilities/dialog/base_dialog.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../../global.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class UserProfileSharePage extends BaseDialog {
  String shareUrl = "";

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
            "分享",
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize22),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(30)),
            child: Container(
              height: ScreenSize.fitPxWidth(200),
              width: ScreenSize.fitPxWidth(200),
              color: Colors.black,
            ),
          ),
          MainBtn(
            isFullWidth: true,
            padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
            backgroundColor: AppColors.orangeColor,
            onPress: () async {
              Clipboard.setData(ClipboardData(text: shareUrl));
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
              await Share.share(shareUrl);
            },
            title: "QrCode 分享",
          ),
        ],
      ),
    );
  }
}
