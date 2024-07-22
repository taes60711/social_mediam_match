import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class PostViewUtilities {
  static Widget noPostData() {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.safeHeight,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.commentSlash,
              size: 50,
              color: hintTextColor,
            ),
            const SizedBox(height: 20),
            Text(
              "沒有文章",
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
}
