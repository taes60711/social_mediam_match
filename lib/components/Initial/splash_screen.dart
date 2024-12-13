import 'package:flutter/material.dart';


import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

Widget splashScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 29, 28, 28),
    body: Center(
      child: SizedBox(
        width: ScreenSize.width,
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Image.asset(logoImg),
        ),
      ),
    ),
  );
}
