import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../pageManager/enum/route_path.dart';
import '../../../pageManager/setting/route_controller.dart';
import '../../../provider/post/post_provider.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

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

  ///文章作るボタン
  static Widget postCreateButton(BuildContext pageContext) {
    return GestureDetector(
      onTap: () {
        /// 文章作成
        RouteOptions.pushTo(
          RoutePath.postEditPage,
          arguments: {
            'postContext': pageContext,
            'allPostBoradTypeList': pageContext.read<PostProvider>().allPostBoards,
            'editorType': "create",
          },
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.edit,
          size: 18,
          color: normalBgColor,
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
