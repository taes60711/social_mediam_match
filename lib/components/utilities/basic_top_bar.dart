import 'package:flutter/material.dart';
import 'style/screen_size.dart';

class BasicTopBar extends StatelessWidget {
  final Function backFunc;
  final String? title;
  final dynamic rightWidget;
  const BasicTopBar({super.key, required this.backFunc, this.title, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    List<Alignment> list = [Alignment.centerLeft, Alignment.center, Alignment.centerRight];

    List<Widget> widgetList = [
      GestureDetector(
        onTap: () {
          backFunc();
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
      Text(title ?? ""),
      rightWidget ?? const SizedBox()
    ];
    return SizedBox(
      width: ScreenSize().width,
      child: Row(
        children: list.asMap().entries.map((entry) {
          int index = entry.key;
          var e = entry.value;

          EdgeInsetsGeometry marginEdgeInsets = const EdgeInsets.all(0);

          if (index == 0) {
            marginEdgeInsets = const EdgeInsets.only(left: 10);
          } else if (index == list.length - 1) {
            marginEdgeInsets = const EdgeInsets.only(right: 10);
          }

          return SizedBox(
            width: ScreenSize().width / 3,
            height: 30,
            child: Container(
              margin: marginEdgeInsets,
              alignment: e,
              child: widgetList[index],
            ),
          );
        }).toList(),
      ),
    );
  }
}
