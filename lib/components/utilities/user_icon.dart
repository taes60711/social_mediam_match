import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: userIcon != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(borderRadius)),
              child: Image.memory(
                const Base64Decoder().convert(userIcon),
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(borderRadius)),
                color: AppColors.greyColor130,
              ),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.userLarge,
                  color: AppColors.whiteColor.withOpacity(.8),
                  size: iconSize - 20 - ScreenSize.fitPxWidth(borderRadius) * 0.2,
                ),
              ),
            ),
    );
  }
}
