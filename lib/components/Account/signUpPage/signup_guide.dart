import 'package:flutter/material.dart';

import '../../../global.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';

class SignUpGuide extends StatelessWidget {
  const SignUpGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: StepGuide.skipButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
            },
          ),
        ),
      ],
    );
  }
}
