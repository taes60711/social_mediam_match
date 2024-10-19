import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../CustomBouncingScrollPhysics.dart';
import 'style/style_config.dart';

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
      backgroundColor: Colors.white,
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backGround),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backGround),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: child,
                ),
              ),
      ),
    );
  }
}

class CommonScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const CommonScaffold({super.key, required this.child});

  @override
  ConsumerState<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends ConsumerState<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 28, 28),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(child: widget.child),
            SizedBox(height: Platform.isIOS ? 30 : 12),
          ],
        ),
      ),
    );
  }
}
