import 'package:flutter/material.dart';

import '../utilities/main_button.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

class AccountPageUtilites {
  Widget logo() {
    return Container(
      width: ScreenSize.fitPxWidth(200),
      height: ScreenSize.fitPxWidth(200),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(
          ScreenSize.fitPxWidth(30),
        ),
      ),
      child: Image.asset('assets/Logo.png'),
    );
  }

  Widget textCheckBuild({required bool condition, required text}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxWidth(2)),
          decoration: BoxDecoration(
            color: condition ? AppColors.purpleColor : AppColors.greyColor57,
            borderRadius: BorderRadius.circular(
              ScreenSize.fitPxWidth(15),
            ),
          ),
          child: Row(
            children: [
              condition
                  ? Icon(
                      Icons.check,
                      color: AppColors.greenColor,
                      size: ScreenSize.fontSize14,
                    )
                  : Icon(
                      Icons.close,
                      color: AppColors.redColor,
                      size: ScreenSize.fontSize14,
                    ),
              SizedBox(width: ScreenSize.fitPxWidth(2)),
              Text(
                text,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
