import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/Icon_with_input.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../states/user_state.dart';
import '../../strings/account/sign_up_strings.dart';

class SignUpStepOne extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController pwdController;
  final Widget signErrorMessage;
  final UserState userFuture;
  const SignUpStepOne({
    super.key,
    required this.emailController,
    required this.nameController,
    required this.pwdController,
    required this.signErrorMessage,
    required this.userFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(StepOnePage().title),
        const SizedBox(height: 10),
        TitleInput(
          title: StepOnePage().nameInputTitle,
          textController: nameController,
        ),
        const SizedBox(height: 10),
        TitleInput(
          title: StepOnePage().pwdInputTitle,
          textController: pwdController,
          isRequired: true,
        ),
        signErrorMessage,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: StepOnePage().signUpButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              log("signUpPage Email:${emailController.text} Pwd:${pwdController.text}");
              userFuture.onChangeSignUpPage(2);
              // bool isSignSucess = await userFuture.signUp(emailController.text, pwdController.text);
              // isSignSucess ? userFuture.onChangeSignUpPage(2) : () => print("sign Failed");
            },
          ),
        ),
      ],
    );
  }
}
