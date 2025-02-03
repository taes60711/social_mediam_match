import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import 'style/screen_size.dart';

class MainBtn extends StatefulWidget {
  ///MARK:機能表示
  // ボタン文字
  final String? title;
  // ボタン文字のスタイル
  final TextStyle? titleStyle;
  final Widget? child;
  // ボタン機能関数
  final Function onPress;

  ///MARK:スタイル
  // ボタン色
  final Color? backgroundColor;
  final bool needOnPressEffect;
  final bool isFullWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double? width;
  final double? height;

  const MainBtn({
    super.key,
    this.title,
    this.titleStyle,
    this.child,
    required this.onPress,
    this.backgroundColor,
    this.needOnPressEffect = true,
    this.isFullWidth = false,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 8,
    this.width,
    this.height,
  });

  @override
  State<MainBtn> createState() => _MainBtnState();
}

class _MainBtnState extends State<MainBtn> {
  bool isPress = false;
  bool canPress = true;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = widget.padding;
    if (widget.title != null && widget.padding == EdgeInsets.zero) {
      padding = EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxHeight(5));
    }

    Color btnBackgroundColor = AppColors.transparent;
    if (widget.title != null) {
      btnBackgroundColor = widget.backgroundColor ?? AppColors.greyColor57;
    }

    double? btnWidth;
    if (widget.isFullWidth) {
      btnWidth = ScreenSize.width;
    } else {
      if (widget.width != null) {
        btnWidth = widget.width;
      }
    }

    double opacityNum = 1;
    if (widget.needOnPressEffect) {
      if (isPress) {
        opacityNum = 0.8;
      } else {
        opacityNum = 1;
      }
    }

    return GestureDetector(
      onTap: () async {
        ///ボタン0.5秒まで押されないよう
        if (canPress) {
          canPress = false;
          await _buttonPressHandle();
          widget.onPress();
          await Future.delayed(const Duration(milliseconds: 500));
          canPress = true;
        }
      },
      child: Container(
        padding: padding,
        margin: widget.margin,
        width: btnWidth,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: btnBackgroundColor,
        ),
        child: Opacity(
          opacity: opacityNum,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child ??
                  Text(
                    widget.title ?? "please use title or child ",
                    style: widget.titleStyle ??
                        TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize12,
                        ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  /// ボタン押すエフェクト
  _buttonPressHandle() async {
    FocusScope.of(context).requestFocus(FocusNode());
    isPress = true;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 150));
    isPress = false;
    setState(() {});
  }
}
