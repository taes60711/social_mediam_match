import 'package:flutter/material.dart';

import 'style/screen_size.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData? icon;
  final String? iconImg;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback onPress;
  const CustomButton({
    super.key,
    required this.title,
    required this.titleColor,
    required this.backgroundColor,
    this.borderRadius,
    required this.onPress,
    this.iconImg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double radius = borderRadius ?? 15.0;
    double iconSize = 25;

    return icon != null
        ? GestureDetector(
            onTap: onPress,
            child: Column(
              children: [
                Icon(icon, color: backgroundColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(color: titleColor),
                )
              ],
            ),
          )
        : Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onPress,
              child: Container(
                width: ScreenSize().width,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconImg != null
                        ? Row(
                            children: [
                              SizedBox(
                                width: iconSize,
                                height: iconSize,
                                child: Image.asset(iconImg ?? "", fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        : Container(),
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
