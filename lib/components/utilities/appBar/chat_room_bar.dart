import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../BottomSheets/user_profile_bottom_sheet.dart';
import '../style/screen_size.dart';
import '../style/app_colors.dart';

class ChatRoomBar extends StatelessWidget {
  final Function? backFunc;
  final Function? rightFunc;
  final dynamic leftWidget;
  final ProfileData userData;
  final TextStyle? titleStyle;
  const ChatRoomBar({
    super.key,
    this.leftWidget,
    this.rightFunc,
    required this.userData,
    this.backFunc,
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
            color: AppColors.transparent,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                size: ScreenSize.fontSize14,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: MainBtn(
            onPress: () {
              UserProfileAllInfoBottomSheet(needToChatRoomBtn: false, userData: userData).show(context);
            },
            child: Row(
              children: [
                UserIcon(iconSize: 40, image: userData.image),
                SizedBox(width: ScreenSize.fitPxWidth(10)),
                Text(
                  userData.name ?? "",
                  style: titleStyle ?? TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (rightFunc != null) {
              rightFunc!();
            }
          },
          child: Container(
            height: ScreenSize.fitPxWidth(40),
            width: ScreenSize.fitPxWidth(40),
            color: AppColors.transparent,
            child: Icon(
              FontAwesomeIcons.bars,
              color: AppColors.greyColor130,
              size: ScreenSize.fontSize18,
            ),
          ),
        ),
      ],
    );
  }
}
