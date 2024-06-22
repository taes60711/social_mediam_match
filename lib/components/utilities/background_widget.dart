import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import 'style/style_config.dart';

class BackgroundWidget extends StatelessWidget {
  final bool isSafeArea;
  final Widget child;
  const BackgroundWidget({
    super.key,
    this.isSafeArea = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    print("background render");

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: isSafeArea
          ? SafeArea(
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
            )
          : Container(
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
    );
  }
}
