import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../utilities/style/app_image.dart';
import '../utilities/style/screen_size.dart';

Widget splashScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.black28,
    body: Center(
      child: SizedBox(
        width: ScreenSize.width,
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Image.asset(AppImage.logo),
        ),
      ),
    ),
  );
}
