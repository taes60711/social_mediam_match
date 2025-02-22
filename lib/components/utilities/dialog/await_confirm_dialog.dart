// delete friend check
import 'package:flutter/material.dart';

import '../main_button.dart';
import '../style/screen_size.dart';
import '../style/app_colors.dart';

Future<bool> awaitConfirmDialog(BuildContext context, {required String title, required String content}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fitPxWidth(25),
                vertical: ScreenSize.fitPxHeight(15),
              ),
              decoration: BoxDecoration(
                color: AppColors.greyColor54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize22),
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                  ),
                  SizedBox(height: ScreenSize.fitPxWidth(20)),
                  Row(
                    children: [
                      Expanded(
                        child: MainBtn(
                          backgroundColor: AppColors.black37,
                          padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                          onPress: () {
                            Navigator.pop(context, false);
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
                            Navigator.pop(context, true);
                          },
                          title: "確認",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}
