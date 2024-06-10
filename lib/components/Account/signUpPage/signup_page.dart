import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
import 'package:social_mediam_match/components/utilities/custom_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/enum/skill_type.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';

import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';
import 'signup_guide.dart';
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
            endDrawerWidget = CustomEndDrawer(
              child: Dismissible(
                direction: DismissDirection.startToEnd,
                resizeDuration: const Duration(milliseconds: 1),
                onDismissed: (_) => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
                key: const Key('key'),
                child: Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
                  return Scaffold(
                    body: Column(
                      children: skillMapProvider.skillMap[SkillType.frontend]!
                          .map(
                            (e) => Row(
                              children: [
                                Expanded(child: Text(e.skillHave.name)),
                                ElevatedButton(
                                    onPressed: () {
                                      skillMapProvider.skillLevelChange(e);
                                    },
                                    child: Text("${e.skillHave.level}"))
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
              ),
            );
          } else if (endDrawer == SignUpEndDrawerType.wantSkill) {
            endDrawerWidget = CustomEndDrawer(
              child: Dismissible(
                direction: DismissDirection.startToEnd,
                resizeDuration: const Duration(milliseconds: 1),
                onDismissed: (_) => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
                key: const Key('key'),
                child: Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
                  return Scaffold(
                    body: Column(
                      children: skillMapProvider.skillMap[SkillType.frontend]!
                          .map(
                            (e) => Row(
                              children: [
                                Expanded(child: Text(e.skillWant.name)),
                                ElevatedButton(
                                    onPressed: () {
                                      skillMapProvider.skillLevelChange(e);
                                    },
                                    child: Text("${e.skillWant.level}"))
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
              ),
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
        signUpStepThird(context),
        const SignUpGuide(),
      ];
      List<String> signUpStepTitle = [
        FirstPage().title,
        StepOnePage().title,
        StepTwoPage().title,
        StepGuide().title,
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

Widget signUpStepThird(BuildContext context) {
  SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
  UserSettingViewProvider userSettingProvider = context.read<UserSettingViewProvider>();
  print("signUpStepThird");

  return Column(
    children: [
      TitleInput(
        title: StepTwoPage().jobInputTitle,
        textController: userSettingProvider.jobInput,
      ),
      Builder(
        builder: (context) {
          print("signUpStepThird introductInput");
          String displayText = context.select((UserSettingViewProvider value) => value.introductionInput.text);
          return MultiTitleInput(
            title: StepTwoPage().introInputTitle,
            textController: userSettingProvider.introductionInput,
            displayText: displayText,
            multiOnChange: (value) => userSettingProvider.inputOnChange(value),
          );
        },
      ),
      GestureDetector(
        onTap: () {
          SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
          signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.haveSkill);
        },
        child: const Row(
          children: [
            Text("能教的技能"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
          signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.wantSkill);
        },
        child: const Row(
          children: [
            Text("想學的技能"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          title: StepTwoPage().sendButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPress: () async {
            signUpViewProvider.onChangeSignUpPage(3);
          },
        ),
      ),
    ],
  );
}
