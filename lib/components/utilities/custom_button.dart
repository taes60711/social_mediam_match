import 'package:flutter/material.dart';

import 'style/screen_size.dart';

class CustomButton extends StatelessWidget {
  final String? iconImg;
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final VoidCallback onPress;
  const CustomButton(
      {super.key,
      required this.title,
      required this.titleColor,
      required this.backgroundColor,
      required this.onPress,
      this.iconImg});

  @override
  Widget build(BuildContext context) {
    double borderRadius = 15.0;
    double iconSize = 25;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
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
