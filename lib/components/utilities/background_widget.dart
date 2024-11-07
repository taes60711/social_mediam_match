import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/theme_style.dart';

import '../../CustomBouncingScrollPhysics.dart';

ScrollController singleScollController = ScrollController();

class BackgroundWidget extends StatelessWidget {
  final bool isSafeArea;
  final bool resizeToAvoidBottomInset;
  final Widget child;
  const BackgroundWidget({
    super.key,
    this.isSafeArea = true,
    this.resizeToAvoidBottomInset = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    print("background render");
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      singleScollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: isSafeArea
            ? SingleChildScrollView(
                controller: singleScollController,
                physics: resizeToAvoidBottomInset ? const NoBouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    width: ScreenSize.width,
                    height: ScreenSize.height,
                    decoration: BoxDecoration(),
                    child: child,
                  ),
                ),
              )
            : SingleChildScrollView(
                controller: singleScollController,
                physics: resizeToAvoidBottomInset ? const NoBouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                child: Container(
                  width: ScreenSize.width,
                  height: ScreenSize.height,
                  decoration: BoxDecoration(),
                  child: child,
                ),
              ),
      ),
    );
  }
}

enum PageType {
  main,
  other,
}

class CommonScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final PageType type;
  const CommonScaffold({super.key, required this.child, this.type = PageType.other});

  @override
  ConsumerState<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends ConsumerState<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeStyle.bgColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          bottom: widget.type == PageType.main ? true : false,
          child: SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height,
            child: Column(
              children: [
                Expanded(child: widget.child),
                // SizedBox(height: Platform.isIOS ? 0 : 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
