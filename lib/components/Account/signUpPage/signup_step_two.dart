import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/account/signUpPage/sign_up_view_model.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';

class SignUpStepTwo extends StatelessWidget {
  const SignUpStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    print("signUpStepTwo");
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    UserSettingViewProvider userSettingProvider = context.read<UserSettingViewProvider>();

    return Column(
      children: [
        TitleInput(
          isRequired: true,
          title: StepTwoPage.pwdInputTitle,
          textController: signUpViewProvider.pwdController,
        ),
        TitleInput(
          title: StepTwoPage.nameInputTitle,
          textController: userSettingProvider.nameInput,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: StepTwoPage.signUpButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async => await SignUpViewModel(context: context).signUpStart(),
          ),
        ),
      ],
    );
  }
}
