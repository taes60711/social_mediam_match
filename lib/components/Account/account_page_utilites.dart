import 'package:flutter/material.dart';

import '../utilities/main_button.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

class AccountPageUtilites {
  Widget btnContainer({required Function onPress, required String btnText, String? imgIcon, Color? btnBgColor}) {
    return MainBtn(
      onPress: () async {
        onPress();
      },
      child: Container(
        width: ScreenSize.width,
        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
        decoration: BoxDecoration(
          color: btnBgColor ?? AppColors.greyColor57,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imgIcon != null
                ? Row(
                    children: [
                      Image.asset(
                        imgIcon,
                        width: ScreenSize.fontSize24,
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(10)),
                    ],
                  )
                : Container(),
            Text(
              btnText,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
