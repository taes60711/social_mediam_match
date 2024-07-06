import 'package:flutter/material.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'style/screen_size.dart';

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
    this.rightWidget = const SizedBox(),
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    List<Alignment> list = [Alignment.centerLeft, Alignment.center, Alignment.centerRight];

    List<Widget> widgetList = [
      leftWidget ??
          GestureDetector(
            onTap: () {
              backFunc != null ? backFunc!() : RouteOptions.pop();
            },
            child: Container(
              width: 35,
              height: 35,
              color: Colors.transparent,
              child: const Center(
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
      centerWidget ?? Text(title),
      rightWidget
    ];

    return SizedBox(
      width: ScreenSize.width,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list.asMap().entries.map((entry) {
            int index = entry.key;
            var e = entry.value;
            return Expanded(
              child: Align(
                alignment: e,
                child: widgetList[index],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
