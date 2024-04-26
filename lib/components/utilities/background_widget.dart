import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    print("background render");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
      ),
    );
  }
}
