import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'style/screen_size.dart';

class RowImgBtn extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String img;
  final double? width;
  final double verticalMargin;
  final Color? btnColor;
  final double? btnRadius;
  final Function onPress;
  const RowImgBtn({
    super.key,
    required this.title,
    this.titleColor = Colors.white,
    required this.btnColor,
    this.btnRadius,
    required this.onPress,
    required this.img,
    this.width,
    this.verticalMargin = 10,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = 25;

    return Material(
      color: btnColor,
      borderRadius: BorderRadius.circular(btnRadius ?? 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(btnRadius ?? 15),
        onTap: () => onPress(),
        child: Container(
          width: width ?? ScreenSize.width,
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                img,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
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
    return Material(
      color: btnColor ?? normalBgColor,
      borderRadius: BorderRadius.circular(btnRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(btnRadius),
        onTap: () => onPress(),
        child: Container(
          alignment: Alignment.center,
          width: btnWidth ?? ScreenSize.width,
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
  final bool isFullWidth;
  final EdgeInsetsGeometry innerPadding;
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
    this.isFullWidth = false,
    this.innerPadding = EdgeInsets.zero,
    this.borderRadius = 8,
    this.width,
    this.height,
  });

  @override
  State<MainBtn> createState() => _MainBtnState();
}

class _MainBtnState extends State<MainBtn> {
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = widget.innerPadding;
    if (widget.title != null && widget.innerPadding == EdgeInsets.zero) {
      padding = EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxHeight(5));
    }

    Color btnBackgroundColor = Colors.transparent;
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

    return GestureDetector(
      onTap: () async {
        await _buttonPressHandle();
        widget.onPress();
      },
      child: Container(
        padding: widget.title != null
            ? EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxHeight(4))
            : padding,
        width: btnWidth,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: btnBackgroundColor,
        ),
        child: Opacity(
          opacity: isPress ? 0.8 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.child ??
                  Text(
                    widget.title ?? "please use title or child ",
                    style: widget.titleStyle ?? const TextStyle(color: Colors.white),
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
