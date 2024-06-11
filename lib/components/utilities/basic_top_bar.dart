import 'package:flutter/material.dart';
import 'style/screen_size.dart';

class BaseTopBar extends StatelessWidget {
  final Function? backFunc;
  final dynamic leftWidget;
  final String? title;
  final dynamic rightWidget;
  final double? padding;
  const BaseTopBar({super.key, this.leftWidget, required this.backFunc, this.title, this.rightWidget, this.padding});

  @override
  Widget build(BuildContext context) {
    List<Alignment> list = [Alignment.centerLeft, Alignment.center, Alignment.centerRight];

    List<Widget> widgetList = [
      leftWidget ??
          GestureDetector(
            onTap: () {
              backFunc!() ?? ();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
      Text(title ?? ""),
      rightWidget ?? const SizedBox()
    ];

    return SizedBox(
      width: ScreenSize.width,
      child: Row(
        children: list.asMap().entries.map(
          (entry) {
            int index = entry.key;
            var e = entry.value;

            EdgeInsetsGeometry marginEdgeInsets = const EdgeInsets.all(0);

            if (index == 0) {
              marginEdgeInsets = EdgeInsets.only(left: padding ?? 10);
            } else if (index == list.length - 1) {
              marginEdgeInsets = EdgeInsets.only(right: padding ?? 10);
            }

            return SizedBox(
              width: ScreenSize.width / 3 - (padding ?? 0 * 2),
              height: 30,
              child: Container(
                margin: marginEdgeInsets,
                alignment: e,
                child: widgetList[index],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
