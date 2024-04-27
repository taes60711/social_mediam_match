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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TitleInput(
                title: StepOnePage().nameInputTitle,
                inputHeight: 36,
                textController: nameController,
              ),
              const SizedBox(height: 10),
              TitleInput(
                title: StepOnePage().pwdInputTitle,
                inputHeight: 36,
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
                    userFuture.onChangePage(2);
                    String email = emailController.text;
                    String pwd = pwdController.text;
                    log("signUpPage Email:$email Pwd:$pwd");
                    // bool isSignSucess = await userFuture.signUp(email, pwd);
                    // isSignSucess ? userFuture.onChangePage(2) : () {print("sign Failed")};
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
