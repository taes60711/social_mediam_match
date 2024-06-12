import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/account/signUpPage/signup_step_third.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
import 'package:social_mediam_match/components/account/signUpPage/skill_choice_setting_page.dart';

import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';

import 'package:social_mediam_match/enum/skill_type.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';

import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';
import 'signup_step_guide.dart';
import 'signup_step_one.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("signUP build");

    return Stack(
      children: [
        BackgroundWidget(
          isSafeArea: true,
          child: StatefulWrapper(
            onInit: () async {
              SkillMapProvider skillProvider = context.read<SkillMapProvider>();
              await skillProvider.userSkillList();
            },
            child: _mainBuild(),
          ),
        ),
        Builder(builder: (context) {
          print("customEndDrawer");
          SignUpEndDrawerType endDrawer = context.select((SignUpViewProvider value) => value.endDrawerOpenInfo);
          SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
          Widget endDrawerWidget = Container();
          if (endDrawer == SignUpEndDrawerType.haveSkill) {
            endDrawerWidget = SkillChoiceSettingPage(
              skillType: SkillChoicePageType.have,
              onDismissedFunc: () => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
            );
          } else if (endDrawer == SignUpEndDrawerType.wantSkill) {
            endDrawerWidget = SkillChoiceSettingPage(
              skillType: SkillChoicePageType.want,
              onDismissedFunc: () => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
            );
          }
          return endDrawerWidget;
        }),
      ],
    );
  }
}

Widget _mainBuild() {
  return Builder(
    builder: (context) {
      print("SignUpViewProvider pageIndex Change");
      int pageIndex = context.select((SignUpViewProvider value) => value.pageIndex);

      List<Widget> signUpAllStepPage = [
        const SignUpStepOne(),
        const SignUpStepTwo(),
        const SignUpStepThird(),
        const SignUpStepGuide(),
      ];

      List<String> signUpStepTitle = [
        StepOnePage.title,
        StepTwoPage.title,
        StepThirdPage.title,
        StepGuide.title,
      ];

      return Column(
        children: [
          BaseTopBar(
            backFunc: () => SignUpViewModel(context: context).backButtonFUnc(),
            title: signUpStepTitle[pageIndex],
          ),
          signUpAllStepPage[pageIndex],
        ],
      );
    },
  );
}
