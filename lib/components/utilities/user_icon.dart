import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'style/screen_size.dart';

///MARK: NormalUserIcon
class UserIcon extends StatelessWidget {
  final double iconSize;
  final String? image;
  final double borderRadius;
  const UserIcon({
    super.key,
    required this.iconSize,
    this.image,
    this.borderRadius = 60,
  });

  @override
  Widget build(BuildContext context) {
    String userIcon = image ?? "";

    return userIcon != ""
        ? Stack(
            children: [
              normalUserIcon(),
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(borderRadius)),
                  child: Image.memory(
                    const Base64Decoder().convert(userIcon),
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          )
        : normalUserIcon();
  }

  Widget normalUserIcon() {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(borderRadius)),
        color: AppColors.greyColor130,
      ),
      child: Padding(
        padding: EdgeInsets.all(iconSize * .2),
        child: Image.asset(
          'assets/normalUserIcon.png',
          fit: BoxFit.cover,
          gaplessPlayback: true,
          color: Colors.white,
        ),
      ),
    );
  }
}
