import 'package:flutter/material.dart';
import '../../../pageManager/setting/route_controller.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';

class SignUpStepGuide extends StatelessWidget {
  const SignUpStepGuide({super.key});

  @override
  Widget build(BuildContext context) {
    print("signUpStepGuide");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextBtn(
            title: StepGuide.skipButtonText,
            titleColor: normalTextColor,
            btnColor: normalBgColor,
            onPress: () => RouteOptions.popUntilToHome(),
          ),
        ),
      ],
    );
  }
}
