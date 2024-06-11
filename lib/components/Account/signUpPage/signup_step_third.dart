import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';

class SignUpStepThird extends StatelessWidget {
  const SignUpStepThird({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
    print("signUpStepThird");

    return Column(
      children: [
        TitleInput(
          title: StepThirdPage.jobInputTitle,
          textController: userSettingViewProvider.jobInput,
        ),
        Builder(
          builder: (context) {
            print("signUpStepThird introductInput");
            String displayText = context.select((UserSettingViewProvider value) => value.introductionInput.text);
            return MultiTitleInput(
              title: StepThirdPage.introInputTitle,
              textController: userSettingViewProvider.introductionInput,
              displayText: displayText,
              multiOnChange: (value) => userSettingViewProvider.inputOnChange(value),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
            signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.haveSkill);
          },
          child: Row(
            children: [
              Text(StepThirdPage.haveSkillText),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
        Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
          return SizedBox(
            width: ScreenSize.width,
            child: Wrap(
              children: skillMapProvider.haveSkillList.map((e) => Text("${e.name} level: ${e.level}")).toList(),
            ),
          );
        }),
        GestureDetector(
          onTap: () {
            SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
            signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.wantSkill);
          },
          child: Row(
            children: [
              Text(StepThirdPage.wantSkillText),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
        Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
          return SizedBox(
            width: ScreenSize.width,
            child: Wrap(
              children: skillMapProvider.wantSkillList.map((e) => Text("${e.name} level: ${e.level}")).toList(),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: StepThirdPage.sendButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              SkillMapProvider skillMapProvider = context.read<SkillMapProvider>();
              print(
                  "name : ${userSettingViewProvider.nameInput.text} job : ${userSettingViewProvider.jobInput.text} introduction : ${userSettingViewProvider.introductionInput.text}");
              print("haveSkillList : ${skillMapProvider.haveSkillList} wantSkillList : ${skillMapProvider.wantSkillList}");

              signUpViewProvider.onChangeSignUpPage(3);
            },
          ),
        ),
      ],
    );
  }
}
