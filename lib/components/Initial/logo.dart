import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: ScreenSize().width,
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.asset('assets/Logo.png'),
          ),
        ),
      ),
    );
  }
}
