import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/components/utilities/style/app_image.dart';

import '../../global.dart';
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

    if (userIcon.contains("http")) {
      // userIcon = userIcon.replaceAll("\$ip", ip);
      // userIcon = userIcon.replaceAll("\$port", port);
      userIcon = userIcon.replaceAll('\$ip:\$port', APIHttpController.domainUrl);
      userIcon = userIcon.replaceAll('\$domain', APIHttpController.domainUrl);
    }

    return userIcon != ""
        ? Stack(
            children: [
              normalUserIcon(),
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(borderRadius)),
                  child: userIcon.contains("http")
                      ? CachedNetworkImage(
                          imageUrl: userIcon,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
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
          AppImage.normalUserIcon,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
