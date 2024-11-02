import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/custom_button.dart';

import '../../../models/user_model.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'editor_page.dart';

class PostViewUtilities {
  ///データなレイアウト
  static Widget noPostData() {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.height,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
              child: Icon(
                FontAwesomeIcons.commentSlash,
                size: 50,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            Text(
              "沒有文章",
              style: TextStyle(
                fontSize: ScreenSize.fontSize20,
                color: AppColors.greyColor130,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topPadding(double bottomBarPos, bool haveTopPost) {
    return AnimatedContainer(
      height: bottomBarPos != ScreenSize.fitPxHeight(-60)
          ? ScreenSize.fitPxHeight(haveTopPost ? 115 : 70)
          : ScreenSize.fitPxHeight(70),
      duration: const Duration(milliseconds: 150),
    );
  }

  Widget userProfileView({required ProfileData userData}) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        UserIcon(
          image: userData.image,
          iconSize: ScreenSize.fitPxHeight(80),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        Container(
          width: ScreenSize.width,
          margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.fitPxHeight(10),
            vertical: ScreenSize.fitPxHeight(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      userData.name ?? "",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize18,
                      ),
                    ),
                  ),
                  Text(
                    "${userData.lastLogin}${tr("skExChpage_beforDays")}",
                    style: TextStyle(
                      color: AppColors.greyColor130,
                      fontSize: ScreenSize.fontSize12,
                    ),
                  ),
                ],
              ),
              Text(
                userData.email,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              Text(
                userData.introduction ?? "",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(15)),
              Center(
                child: MainBtn(
                  onPress: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxHeight(15),
                      vertical: ScreenSize.fitPxHeight(5),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.greyColor54,
                    ),
                    child: Text(
                      "新增好友",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        Container(
          width: ScreenSize.width,
          margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.fitPxHeight(10),
            vertical: ScreenSize.fitPxHeight(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "職業",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize14,
                ),
              ),
              Text(
                userData.job ?? "",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              Row(
                children: [
                  Text(
                    "信箱認證",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: ScreenSize.fontSize14,
                    ),
                  ),
                  SizedBox(width: ScreenSize.fitPxWidth(10)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ScreenSize.fitPxWidth(5),
                        ),
                        color: userData.isEmailVerified ? Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
                    child: Text(
                      userData.isEmailVerified ? "已認證" : "未認證",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenSize.fitPxHeight(5)),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(15)),
      ],
    );
  }

  ///文章作るボタン
  static Widget postCreateButton(BuildContext context) {
    return MainBtn(
      onPress: () {
        PostEditorPage().show(context);
      },
      child: Container(
        width: ScreenSize.fitPxWidth(40),
        height: ScreenSize.fitPxWidth(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.whiteColor,
        ),
        child: Icon(
          FontAwesomeIcons.pen,
          size: 16,
          color: AppColors.orangeColor,
        ),
      ),
    );
  }

  ///何も検索しているレイアウト
  static Widget noinitSearchWidget() {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.safeHeight,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.search,
              size: 50,
              color: hintTextColor,
            ),
            const SizedBox(height: 20),
            Text(
              "請輸入關鍵字搜尋",
              style: TextStyle(
                fontSize: 20,
                color: normalBgColor2,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconWithText({required IconData iconData, Color? iconColor, required String text, TextStyle? style}) {
    return Row(
      children: [
        Icon(iconData, size: 14, color: iconColor),
        const SizedBox(width: 5),
        Text(
          text,
          style: style ?? const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
