import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';
import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../skill_bar.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';

class SignUpStepThird extends StatelessWidget {
  const SignUpStepThird({super.key});

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 10),
        skillSettingTitleBarBtn(SignUpEndDrawerType.haveSkill),
        const SizedBox(height: 20),
        skillSettingTitleBarBtn(SignUpEndDrawerType.wantSkill),
        const SizedBox(height: 10),
        sendBtn(context),
      ],
    );
  }
}

Widget sendBtn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: CustomButton(
      title: StepThirdPage.sendButtonText,
      titleColor: normalTextColor,
      backgroundColor: normalBgColor,
      onPress: () async {
        await SignUpViewModel(context: context).updateUserData();
      },
    ),
  );
}

Widget skillSettingTitleBarBtn(SignUpEndDrawerType type) {
  return Consumer<UserSettingViewProvider>(builder: (context, userSettingViewProvider, _) {
    List<RequestUserSkillData> skillData = userSettingViewProvider.haveSkillList;
    if (type != SignUpEndDrawerType.haveSkill) {
      skillData = userSettingViewProvider.wantSkillList;
    }

    String btnText = type == SignUpEndDrawerType.haveSkill ? StepThirdPage.haveSkillText : StepThirdPage.wantSkillText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
            signUpViewProvider.changeEndDrawerStatus(type);
          },
          child: Row(
            children: [
              Text(btnText),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              Text("(${skillData.length} / 5)"),
            ],
          ),
        ),
        skillBar(type, proivderType: context.read<UserSettingViewProvider>()),
      ],
    );
  });
}
