import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'style/screen_size.dart';

class RowImgBtn extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String img;
  final double? width;
  final double verticalMargin;
  final Color? backgroundColor;
  final double? borderRadius;
  final Function onPress;
  const RowImgBtn({
    super.key,
    required this.title,
    this.titleColor = Colors.white,
    required this.backgroundColor,
    this.borderRadius,
    required this.onPress,
    required this.img,
    this.width,
    this.verticalMargin = 10,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = 25;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius ?? 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
        onTap: () {
          onPress();
        },
        child: Container(
          width: width ?? ScreenSize.width,
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: Image.asset(
                  img,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: titleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextBtn extends StatelessWidget {
  final double? btnWidth;
  final Color? btnColor;
  final double btnRadius;
  final double verticalMargin;
  final String title;
  final Color titleColor;
  final Function onPress;

  const TextBtn({
    super.key,
    this.btnWidth,
    this.btnColor,
    this.btnRadius = 15,
    this.verticalMargin = 10,
    required this.title,
    this.titleColor = Colors.white,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    Color btnBgColor = btnColor ?? normalBgColor;
    double btnW = btnWidth ?? ScreenSize.width;
    return Material(
      color: btnBgColor,
      borderRadius: BorderRadius.circular(btnRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(btnRadius),
        onTap: () {
          onPress();
        },
        child: Container(
          alignment: Alignment.center,
          width: btnW,
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          child: Text(
            title,
            style: TextStyle(color: titleColor),
          ),
        ),
      ),
    );
  }
}

class ColIconBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final String title;
  final Color? titleColor;
  final Function onPress;
  const ColIconBtn({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconSize = 25,
    required this.title,
    this.titleColor,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor ?? normalBgColor,
              size: iconSize,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: titleColor ?? normalBgColor2),
            )
          ],
        ),
      ),
    );
  }
}
