import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../strings/account/sign_up_strings.dart';

class SignUpGuide extends StatelessWidget {
  final Function returnHomePage;
  const SignUpGuide({super.key, required this.returnHomePage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(StepGuide().title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
              title: StepGuide().skipButtonText,
              titleColor: normalTextColor,
              backgroundColor: normalBgColor,
              onPress: () {
                returnHomePage();
              }),
        ),
      ],
    );
  }
}
