import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

class SignUpGuide extends StatelessWidget {
  final Function returnHomePage;
  const SignUpGuide({super.key, required this.returnHomePage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("導覽"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
              title: "跳過",
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
