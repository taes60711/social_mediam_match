import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../../../global.dart';
import '../main_button.dart';
import '../style/screen_size.dart';

class BaseTopBar extends StatelessWidget {
  final Function? backFunc;
  final dynamic leftWidget;
  final String title;
  final dynamic centerWidget;
  final dynamic rightWidget;
  final EdgeInsetsGeometry padding;
  const BaseTopBar({
    super.key,
    this.leftWidget,
    this.backFunc,
    this.title = "",
    this.centerWidget,
    this.rightWidget,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    List<Alignment> list = [Alignment.centerLeft, Alignment.center, Alignment.centerRight];

    List<Widget> widgetList = [
      leftWidget ??
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
      centerWidget ??
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
          ),
      rightWidget ?? Container(),
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        color: AppColors.transparent,
        width: ScreenSize.width,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: list[0],
                  child: widgetList[0],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: ScreenSize.fitPxWidth(260),
                ),
                child: Align(
                  alignment: list[1],
                  child: widgetList[1],
                ),
              ),
              rightWidget != null
                  ? Align(
                      alignment: list[2],
                      child: widgetList[2],
                    )
                  : Expanded(
                      child: Align(
                        alignment: list[2],
                        child: widgetList[2],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget downCloseBtn({Function? onPress}) {
  return MainBtn(
    onPress: () {
      if (onPress != null) {
        onPress();
      }
    },
    child: Container(
      width: ScreenSize.fitPxWidth(40),
      height: ScreenSize.fitPxWidth(40),
      color: AppColors.transparent,
      child: Center(
        child: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.whiteColor,
        ),
      ),
    ),
  );
}
