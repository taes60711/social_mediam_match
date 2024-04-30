import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../states/user_state.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/title_input.dart';

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
    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: Color.fromARGB(50, 0, 0, 0),
        context: context,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    void closePop() {
      if (!ModalRoute.of(context)!.isCurrent) {
        Navigator.of(context).pop();
      }
    }

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
              loadingPopView();
              log("signUpPage Email:${emailController.text} Pwd:${pwdController.text}");

              await Future.delayed(const Duration(seconds: 1)).then((value) => closePop());
              userFuture.onChangeSignUpPage(2);

              // bool isSignSucess = await userFuture.signUp(emailController.text, pwdController.text);
              // closePop();
              // isSignSucess ? userFuture.onChangeSignUpPage(2) : () => print("sign Failed");
            },
          ),
        ),
      ],
    );
  }
}
