import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class BackgroundWidget extends StatelessWidget {
  final bool? isSafeArea;
  final Widget child;
  const BackgroundWidget({super.key, this.isSafeArea, required this.child});

  @override
  Widget build(BuildContext context) {
    print("background render");
    bool isSafeArea = this.isSafeArea ?? true;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: isSafeArea
          ? SafeArea(
              child: Container(
                width: ScreenSize().width,
                height: ScreenSize().height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: child,
              ),
            )
          : Container(
              width: ScreenSize().width,
              height: ScreenSize().height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: child,
            ),
    );
  }
}
