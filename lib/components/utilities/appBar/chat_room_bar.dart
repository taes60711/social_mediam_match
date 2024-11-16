import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../global.dart';
import '../style/screen_size.dart';
import '../style/style_config.dart';

class ChatRoomBar extends StatelessWidget {
  final Function? backFunc;
  final dynamic leftWidget;
  final String? userImg;
  final String title;
  final TextStyle? titleStyle;
  const ChatRoomBar({
    super.key,
    this.leftWidget,
    this.userImg,
    this.backFunc,
    this.title = "",
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            backFunc != null ? backFunc!() : Navigator.of(globalContext).pop();
          },
          child: Container(
            width: ScreenSize.fitPxWidth(40),
            height: ScreenSize.fitPxWidth(40),
            color: Colors.transparent,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                size: ScreenSize.fontSize14,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
        UserIcon(iconSize: 40, image: userImg),
        SizedBox(
          width: ScreenSize.fitPxWidth(10),
        ),
        Text(
          title,
          style: titleStyle ?? const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
