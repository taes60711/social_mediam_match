import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/theme_style.dart';

enum PageType {
  main,
  other,
  window,
}

class SafeAreaViewModel {
  final bool top;
  final bool bottom;
  SafeAreaViewModel({this.top = false, this.bottom = false});
}

class CommonScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final PageType type;
  final Color? bgColor;
  const CommonScaffold({super.key, required this.child, this.type = PageType.other, this.bgColor});

  @override
  ConsumerState<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends ConsumerState<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.bgColor ?? ThemeStyle.bgColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          top: getSafeArea().top,
          bottom: getSafeArea().bottom,
          child: Container(child: widget.child),
        ),
      ),
    );
  }

  SafeAreaViewModel getSafeArea() {
    switch (widget.type) {
      case PageType.main:
        return SafeAreaViewModel(bottom: true, top: true);
      case PageType.other:
        return SafeAreaViewModel(bottom: false, top: true);
      case PageType.window:
        return SafeAreaViewModel(bottom: false, top: false);
    }
  }
}
